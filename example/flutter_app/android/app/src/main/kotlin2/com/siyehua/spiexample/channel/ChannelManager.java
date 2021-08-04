package com.siyehua.spiexample.channel;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.UiThread;


import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
/**
 * <br>
 * ChannelManager manager all changer interfaces.<br>
 * add interface impl, use {@link #addChannelImpl(Class, Object)}},<br>
 * get interface impl, use {@link #getChannel(Class)}.<br>
 * more info, see {@link 'https://pub.dev/packages/spi_flutter_package'}
 */
public class ChannelManager {
    private interface ErrorCode {
        String NoFoundChannel = "400";//can't found channel
        String NoFoundMethod = "401";//can't found method
        String CanNotMatchArgs = "402"; //can not match method's args
    }

    public interface Result<T> {
        /**
         * Handles a successful result.
         *
         * @param result The result, possibly null. The result must be an Object type supported by the
         *               codec. For instance, if you are using StandardMessageCodec (default), please see
         *               its documentation on what types are supported.
         */
        @UiThread
        void success(@Nullable T result);

        /**
         * Handles an error result.
         *
         * @param errorCode    An error code String.
         * @param errorMessage A human-readable error message String, possibly null.
         * @param errorDetails Error details, possibly null. The details must be an Object type
         *                     supported by the codec. For instance, if you are using StandardMessageCodec
         *                     (default), please see its documentation on what types are supported.
         */
        @UiThread
        void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails);

        /**
         * Handles a call to an unimplemented method.
         */
        @UiThread
        void notImplemented();
    }

    /**
     * json parse
     */
    public interface JsonParse {
        /**
         * passe object to json
         * @param object object
         * @return json str
         */
        @Nullable
        public String toJSONString(@Nullable Object object);

        /**
         * parse json str to obj
         * @param text json
         * @param clazz obj class
         * @param <T> class type
         * @return obj
         */
        @Nullable
        public <T> T parseObject(@Nullable String text, @NonNull Class<T> clazz);
    }

    private static final String channelName = "com.siyehua.example.chanel.name2";
    private static final Map<String, Object> channelImplMap = new ConcurrentHashMap<>();
    private static MethodChannel methodChannel;
    private static final Handler handler = new Handler(Looper.getMainLooper());
    private static JsonParse jsonParse;//json parse

    public static void init(@NonNull final BinaryMessenger messenger, @NonNull  JsonParse jsonParse) {
        ChannelManager.jsonParse = jsonParse;
        MethodChannel methodChannel = new MethodChannel(messenger, channelName);
        ChannelManager.methodChannel = methodChannel;
        methodChannel.setMethodCallHandler((call, result) -> {
            String callClass = call.method.split("#")[0];
            String callMethod = call.method.split("#")[1];
            Object targetChanel = channelImplMap.get(callClass);
            if (targetChanel != null) {
                Method[] methods = targetChanel.getClass().getDeclaredMethods();
                Method method = null;
                for (Method item : methods) {
                    if (item.getName().equals(callMethod)) {
                        method = item;
                        break;
                    }
                }
                if (method == null) {
                    result.error(ErrorCode.NoFoundMethod, "can't found method: " + callMethod, null);
                    return;
                }
                boolean should = true;
                List<Object> argList = call.arguments();
                if (argList == null) {
                    argList = new ArrayList<>();
                }
                Class<?>[] types = method.getParameterTypes();
                if (types.length > 0) {
                    if (types[types.length - 1] == Result.class) {
                        should = false;
                        argList.add(new Result() {
                            @Override
                            public void success(@Nullable Object value) {
                                final Object newValue = customClassToString(value);
                                handler.post(() -> result.success(newValue));
                            }

                            @Override
                            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                                handler.post(() -> result.error(errorCode, errorMessage, errorDetails));
                            }

                            @Override
                            public void notImplemented() {
                                handler.post(result::notImplemented);
                            }
                        });
                    }
                }
                Object[] args = argList.toArray();
                //cover integer to long
                for (int i = 0; i < args.length; i++) {
                    if (args[i] == null) {
                        continue;
                    }
                    Object parseCustom = stringToCustomClass(args[i], ".flutter2native.");
                    args[i] = parseCustom;
                    args[i] = intToLong(args[i]);
                }
                try {
                    Object invokeResult = method.invoke(targetChanel, args);
                    if (should) {
                        result.success(invokeResult);
                    }
                } catch (InvocationTargetException e) {
                    result.error("Invoke Error", e.getMessage(), Log.getStackTraceString(e.getTargetException()));
                } catch (IllegalAccessException | IllegalArgumentException e) {
                    result.error(ErrorCode.CanNotMatchArgs, targetChanel.getClass().getSimpleName()
                            + " invoke method: " + callMethod
                            + " argument:" + Arrays.toString(method.getParameterTypes())
                            + " receiver args: " + Arrays.toString(args), Log.getStackTraceString(e));
                } catch (Exception e) {
                    result.error("Invoke Error", e.getMessage(), Log.getStackTraceString(e));
                }
            } else {
                result.error(ErrorCode.NoFoundChannel, "can't found channel: " + callClass
                        + ", do you call ChannelManager.addChannelImpl() in Android Platform ?", null);
            }
        });
    }

    public static <T> void addChannelImpl(Class<T> clsName, T object) {
        channelImplMap.put(clsName.getName(), object);
    }

    public static <T> T getChannel(Class<T> clsName) {
        return (T) channelImplMap.get(clsName.getName());
    }

    public static <T> void invoke(Class<?> clsName, String method, List args, @Nullable Result<T> callback) {
        ArrayList newList = new ArrayList();
        for (Object item : args) {
            newList.add(customClassToString(item));
        }
        methodChannel.invokeMethod(clsName + "#" + method, newList, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                if (callback != null) {
                    //noinspection unchecked
                    T parse = (T) stringToCustomClass(result, ".native2flutter.");
                    if (parse != null) {
                        callback.success(parse);
                    } else {
                        //noinspection unchecked
                        callback.success((T) result);
                    }
                }
            }

            @Override
            public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                if (callback != null) {
                    callback.error(errorCode, errorMessage, errorDetails);
                }
            }

            @Override
            public void notImplemented() {
                if (callback != null) {
                    callback.notImplemented();
                }
            }
        });
    }
  

    @SuppressWarnings({"UnnecessaryLocalVariable", "rawtypes", "unchecked"})
    private static Object intToLong(Object object) {
        if (object instanceof Integer) {
            Long newValue = (Long) ((Integer) object).longValue();
            return newValue;
        } else if (object instanceof ArrayList) {
            ArrayList tmpArg = (ArrayList) object;
            if (tmpArg.isEmpty()) {
                return object;
            }
            ArrayList newList = new ArrayList();
            for (Object item : tmpArg) {
                newList.add(intToLong(item));
            }
            return newList;
        } else if (object instanceof HashMap) {
            HashMap tmpArg = (HashMap) object;
            if (tmpArg.isEmpty()) {
                return object;
            }
            HashMap newMap = new HashMap();
            for (Object item : tmpArg.keySet()) {
                Object key = intToLong(item);
                Object value = intToLong(tmpArg.get(item));
                newMap.put(key, value);
            }
            return newMap;
        } else {
            return object;
        }
    }

    @SuppressWarnings({"rawtypes", "unchecked", "UnnecessaryLocalVariable"})
    private static Object customClassToString(Object data) {
        if (data != null && data.getClass().getName().startsWith(channelName)) {
            String customInfo = data.getClass().getSimpleName() + "___custom___" + jsonParse.toJSONString(data);
            return customInfo;
        } else if (data instanceof ArrayList) {
            ArrayList newList = new ArrayList();
            for (Object item : (ArrayList) data) {
                newList.add(customClassToString(item));
            }
            return newList;
        } else if (data instanceof HashMap) {
            HashMap newMap = new HashMap();
            for (Object item : ((HashMap) data).keySet()) {
                Object key = customClassToString(item);
                Object value = customClassToString(((HashMap) data).get(item));
                newMap.put(key, value);
            }
            return newMap;
        }
        return data;
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    private static Object stringToCustomClass(Object data, String pre) {
        try {
            if (data instanceof String && ((String) data).contains("___custom___")) {
                String[] customInfo = ((String) data).split("___custom___");
                Class cls = Class.forName(channelName + pre + customInfo[0]);
                //noinspection unchecked
                return jsonParse.parseObject(customInfo[1], cls);
            } else if (data instanceof ArrayList) {
                ArrayList newList = new ArrayList();
                for (Object item : (ArrayList) data) {
                    newList.add(stringToCustomClass(item, pre));
                }
                return newList;
            } else if (data instanceof HashMap) {
                HashMap newMap = new HashMap();
                for (Object item : ((HashMap) data).keySet()) {
                    Object key = stringToCustomClass(item, pre);
                    Object value = stringToCustomClass(((HashMap) data).get(item), pre);
                    newMap.put(key, value);
                }
                return newMap;
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return data;
    }


    static {

    }

}




String javaStr = '''
package tool;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.UiThread;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

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
         *               codec. For instance, if you are using {@link StandardMessageCodec} (default), please see
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
         *                     supported by the codec. For instance, if you are using {@link StandardMessageCodec}
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

    private static final String channelName = "123456";
    private static final Map<String, Object> channelImplMap = new ConcurrentHashMap<>();
    private static MethodChannel methodChannel;
    private static final Handler handler = new Handler(Looper.getMainLooper());

    public static void init(@NonNull final BinaryMessenger messenger) {
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
                                handler.post(() -> result.success(value));
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
                    if (args[i].getClass() == Integer.class) {
                        Long tmpArg = ((Integer) args[i]).longValue();
                        args[i] = tmpArg;
                    } else if (args[i].getClass() == ArrayList.class) {
                        ArrayList tmpArg = (ArrayList) args[i];
                        if (tmpArg.isEmpty()) {
                            continue;
                        }
                        ArrayList newList = new ArrayList();
                        for (Object item : tmpArg) {
                            if (item.getClass() == Integer.class) {
                                //如果是 integer, 则强行转成成 long
                                Long newValue = ((Integer) item).longValue();
                                newList.add(newValue);
                            } else {
                                newList.add(item);
                            }
                        }
                        //修改成新的 list
                        args[i] = newList;
                    } else if (args[i].getClass() == HashMap.class) {
                        HashMap tmpArg = (HashMap) args[i];
                        if (tmpArg.isEmpty()) {
                            continue;
                        }
                        HashMap newMap = new HashMap();
                        for (Object item : tmpArg.keySet()) {
                            Object key = item;
                            Object value = tmpArg.get(item);
                            if (item.getClass() == Integer.class) {
                                //如果是 integer, 则强行转成成 long
                                key = ((Integer) item).longValue();
                            }
                            if (value != null && value.getClass() == Integer.class) {
                                value = ((Integer) value).longValue();
                            }
                            newMap.put(key, value);
                        }
                        args[i] = newMap;
                    }
                }
                try {
                    Object invokeResult = method.invoke(targetChanel, args);
                    if (should) {
                        result.success(invokeResult);
                    }
                 } catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
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

    public static <T> void invoke(Class<?> clsName, String method, Object args, @Nullable Result<T> callback) {
        methodChannel.invokeMethod(clsName + "#" + method, args, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                if (callback != null) {
                    callback.success((T) result);
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

    static {
        //generated add native2flutter impl in this
    }

}

''';
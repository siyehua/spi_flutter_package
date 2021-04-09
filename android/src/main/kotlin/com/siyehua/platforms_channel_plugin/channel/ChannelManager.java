package com.siyehua.platforms_channel_plugin.channel;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.UiThread;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import com.siyehua.platforms_channel_plugin.channel.native2flutter.IAccount2;
import com.siyehua.platforms_channel_plugin.channel.native2flutter.IAccount2Impl;

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

    private static final String channelName = "com.siyehua.platforms_channel_plugin.channel";
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
                try {
                    Object invokeResult = method.invoke(targetChanel, args);
                    if (should) {
                        result.success(invokeResult);
                    }
                } catch (IllegalAccessException | InvocationTargetException e) {
                    result.error(ErrorCode.CanNotMatchArgs, "can not match method's args: " + Arrays.toString(args), null);
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
        addChannelImpl(IAccount2.class, new IAccount2Impl());
    }

}


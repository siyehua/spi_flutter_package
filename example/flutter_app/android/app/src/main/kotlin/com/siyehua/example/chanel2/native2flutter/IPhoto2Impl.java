package com.siyehua.example.chanel2.native2flutter;

import com.siyehua.example.chanel2.ChannelManager;
import com.siyehua.example.chanel2.ChannelManager.Result;
import com.siyehua.example.chanel2.flutter2native.*;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
public class IPhoto2Impl  implements IPhoto2{
	@Override
	public void aaa() {
		List args = new ArrayList();
		ChannelManager.invoke(this.getClass().getInterfaces()[0], "aaa", args, null);
	}
}

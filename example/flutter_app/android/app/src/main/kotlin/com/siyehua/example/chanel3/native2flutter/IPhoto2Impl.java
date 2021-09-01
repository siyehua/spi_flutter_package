package com.siyehua.example.chanel3.native2flutter;

import com.siyehua.example.chanel3.ChannelManager;
import com.siyehua.example.chanel3.ChannelManager.Result;
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

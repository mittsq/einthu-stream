package me.basak.einthustream;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "me.basak.einthustream/";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL + "cast").setMethodCallHandler(
        (methodCall, result) -> {

        }
    );

    new MethodChannel(getFlutterView(), CHANNEL+"apk").setMethodCallHandler(
        (methodCall, result) -> {
          if (methodCall.method.equals("installApk")) {
            File apkFile = new File((String)methodCall.argument("path"));
            Intent intent = new Intent(Intent.ACTION_VIEW);
            Uri fileUri = android.support.v4.content.FileProvider.getUriForFile(this, getApplicationContext().getPackageName() + ".provider", apkFile);
            intent.setDataAndType(fileUri, "application/vnd.android.package-archive");
            intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            startActivity(intent);
            result.success(null);
            return;
          }
        }
    );
  }
}

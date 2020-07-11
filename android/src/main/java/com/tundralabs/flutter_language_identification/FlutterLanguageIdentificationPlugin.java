package com.tundralabs.flutter_language_identification;

import android.content.Context;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.mlkit.nl.languageid.IdentifiedLanguage;
import com.google.mlkit.nl.languageid.LanguageIdentification;
import com.google.mlkit.nl.languageid.LanguageIdentifier;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/** FlutterLanguageIdentificationPlugin */
public class FlutterLanguageIdentificationPlugin implements FlutterPlugin, MethodCallHandler {
  private Handler handler;
  private MethodChannel channel;
  private LanguageIdentifier languageIdentification;
  private static final String TAG = "Language_Identification";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    initInstance(
        flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());
  }

  public static void registerWith(Registrar registrar) {
    FlutterLanguageIdentificationPlugin instance = new FlutterLanguageIdentificationPlugin();
    instance.initInstance(registrar.messenger(), registrar.activeContext());
  }

  private void initInstance(BinaryMessenger messenger, Context context) {
    channel = new MethodChannel(messenger, "flutter_language_identification");
    channel.setMethodCallHandler(this);
    handler = new Handler();
    languageIdentification = LanguageIdentification.getClient();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("identifyLanguage")) {
      String text = call.arguments.toString();
      identifyLanguage(text);
      result.success(1);
    } else if (call.method.equals("identifyPossibleLanguages")) {
      String text = call.arguments.toString();
      identifyPossibleLanguages(text);
      result.success(1);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void identifyPossibleLanguages(final String inputText) {
    languageIdentification = LanguageIdentification.getClient();
    languageIdentification
        .identifyPossibleLanguages(inputText)
        .addOnSuccessListener(
            new OnSuccessListener<List<IdentifiedLanguage>>() {
              @Override
              public void onSuccess(List<IdentifiedLanguage> identifiedLanguages) {
                List<String> detectedLanguages = new ArrayList<>(identifiedLanguages.size());
                for (IdentifiedLanguage language : identifiedLanguages) {
                  detectedLanguages.add(
                      String.format(
                          Locale.US,
                          "%s (%3f)",
                          language.getLanguageTag(),
                          language.getConfidence()));
                }
                invokeMethod(
                    "identifyPossibleLanguages.onSuccess", TextUtils.join(", ", detectedLanguages));
              }
            })
        .addOnFailureListener(
            new OnFailureListener() {
              @Override
              public void onFailure(@NonNull Exception e) {
                Log.e(TAG, "Language identification error", e);
                invokeMethod("identifyPossibleLanguages.onError", e);
              }
            });
  }

  private void identifyLanguage(final String inputText) {
    languageIdentification
        .identifyLanguage(inputText)
        .addOnSuccessListener(
            new OnSuccessListener<String>() {
              @Override
              public void onSuccess(@Nullable String languageCode) {
                if (languageCode.equals("und")) {
                  Log.i(TAG, "Can't identify language");
                  invokeMethod("identifyLanguage.onFailed", languageCode);
                } else {
                  invokeMethod("identifyLanguage.onSuccess", languageCode);
                }
              }
            })
        .addOnFailureListener(
            new OnFailureListener() {
              @Override
              public void onFailure(@NonNull Exception e) {
                Log.e(TAG, "Language identification error", e);
                invokeMethod("identifyLanguage.onError", e);
              }
            });
  }

  private void invokeMethod(final String method, final Object arguments) {
    handler.post(
        new Runnable() {
          @Override
          public void run() {
            channel.invokeMethod(method, arguments);
          }
        });
  }
}

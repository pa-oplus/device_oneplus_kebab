/*
 * Copyright (C) 2026 Paranoid Android
 * SPDX-License-Identifier: Apache-2.0
 */
package co.aospa.kebab.input;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.util.Log;
import android.view.InputDevice;
import android.view.KeyEvent;

import com.android.internal.os.DeviceKeyHandler;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/** Default OnePlus slider behavior through PA's device key-handler hook. */
public final class KeyHandler implements DeviceKeyHandler {
    private static final String TAG = "KebabKeyHandler";
    private static final String SLIDER_DEVICE = "oplus,hall_tri_state_key";
    private static final String SLIDER_STATE = "/proc/tristatekey/tri_state";
    private final AudioManager mAudioManager;
    private final String mStatePath;

    public KeyHandler(Context context) {
        this(context, SLIDER_STATE);
    }

    KeyHandler(Context context, String statePath) {
        mAudioManager = context.getSystemService(AudioManager.class);
        mStatePath = statePath;
        context.registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
                    restoreSliderState();
                }
            }
        }, new IntentFilter(Intent.ACTION_BOOT_COMPLETED), Context.RECEIVER_NOT_EXPORTED);
    }

    @Override
    public KeyEvent handleKeyEvent(KeyEvent event) {
        InputDevice device = event.getDevice();
        if (device == null || !SLIDER_DEVICE.equals(device.getName())) return event;
        if (event.getAction() == KeyEvent.ACTION_DOWN && event.getRepeatCount() == 0) {
            restoreSliderState();
        }
        // Consume both halves of the slider event; do not leak its keys to apps.
        return null;
    }

    private void restoreSliderState() {
        if (mAudioManager == null) return;
        try (BufferedReader reader = new BufferedReader(new FileReader(mStatePath))) {
            String value = reader.readLine();
            int state = Integer.parseInt(value == null ? "" : value.trim());
            final int mode;
            switch (state) {
                case 1: mode = AudioManager.RINGER_MODE_SILENT; break;
                case 2: mode = AudioManager.RINGER_MODE_VIBRATE; break;
                case 3: mode = AudioManager.RINGER_MODE_NORMAL; break;
                default: return;
            }
            mAudioManager.setRingerModeInternal(mode);
        } catch (IOException | RuntimeException e) {
            Log.w(TAG, "Could not apply alert slider state", e);
        }
    }
}

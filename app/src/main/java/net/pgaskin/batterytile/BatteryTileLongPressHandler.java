// SPDX-FileCopyrightText: 2023-2026 Patrick Gaskin
// SPDX-License-Identifier: MIT
package net.pgaskin.batterytile;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class BatteryTileLongPressHandler extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        startActivity(new Intent(Intent.ACTION_POWER_USAGE_SUMMARY));
        finish();
    }
}

package com.QtRask.Launcher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class PackageBroadcast: BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val packageName = intent.data!!.schemeSpecificPart

        if (packageName == null || packageName.isEmpty())
            return

        val action = intent.action
        if (action == "android.intent.action.PACKAGE_ADDED") {
            Log.d(TAG, "Added Package name: " + packageName)
            if (RaskLauncher.isAppLaunchable(packageName))
                RaskLauncher.packageAdded(packageName)
        } else if (action == "android.intent.action.PACKAGE_REMOVED") {
            Log.d(TAG, "Removed Package name: " + packageName)
            RaskLauncher.packageRemoved(packageName)
        }
    }

    companion object {
        private val TAG = "BroadcastReceiver"
    }
}

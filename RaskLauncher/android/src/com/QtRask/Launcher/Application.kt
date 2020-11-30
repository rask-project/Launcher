package com.QtRask.Launcher

class Application(var name: String, var packageName: String, var iconType: String) : Comparable<Application>
{
    override fun compareTo(application: Application): Int {
        return this.name.toUpperCase().compareTo(application.name.toUpperCase())
    }
}

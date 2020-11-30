#pragma once

#include <QDebug>
#include <QtAndroidExtras>

namespace UtilsJni
{

inline QString jstringToQString(jstring string)
{
    QAndroidJniEnvironment env;
    return QString(env->GetStringUTFChars(string, nullptr));
}

}

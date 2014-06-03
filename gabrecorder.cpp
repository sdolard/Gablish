#include "gabrecorder.h"


GabRecorder::GabRecorder()
{
}

GabRecorder::~GabRecorder()
{
}

void GabRecorder::record()
{
    qDebug() << "Called the C++ method";
}

QString GabRecorder::tmp() const
{
    return m_tmp;
}
void GabRecorder::setTmp(const QString &t)
{
    if (t == m_tmp)
        return;
    m_tmp = t;
    emit tmpChanged(m_tmp);
}

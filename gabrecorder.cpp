#include <QStandardPaths>

#include "gabrecorder.h"

GabRecorder::GabRecorder()
{
    qDebug() << "supportedAudioCodecs: " << m_recorder.supportedAudioCodecs().join(',');

#ifdef Q_OS_MAC
    m_audioSettings.setCodec("audio/pcm");
    setOutput("rec1.wav"); //TODO: Should be id base !
#endif

    m_recorder.setAudioSettings(m_audioSettings);
}

GabRecorder::~GabRecorder()
{
}

void GabRecorder::record()
{
    m_recorder.record();
}

void GabRecorder::stop()
{
    m_recorder.stop();
}

QString GabRecorder::codec() const
{
    return m_audioSettings.codec();
}

void GabRecorder::setCodec(const QString &codec)
{
    if (codec == m_audioSettings.codec())
        return;
    if (m_recorder.supportedAudioCodecs().indexOf(codec) == -1)
    {
        qDebug() << "Unsupported audio codec: " << codec;
        return;
    }
    m_audioSettings.setCodec(codec);
    m_recorder.setAudioSettings(m_audioSettings);

    emit codecChanged(codec);
}

QUrl GabRecorder::output() const
{
    return m_output;
}

bool GabRecorder::setOutput(const QString &filename)
{
    QString p = QDir(QStandardPaths::writableLocation(QStandardPaths::MusicLocation)).filePath(filename);

    if (p == m_output)
        return false;
    m_output = p;
    QUrl url(QUrl::fromLocalFile(p));
    m_recorder.setOutputLocation(url);
    return true;
}

QString GabRecorder::filename() const
{
    return QFile(m_output).fileName();
}

void GabRecorder::setFilename(const QString & filename)
{
    QFile file(m_output);
    if (filename == file.fileName())
        return;
    if (setOutput(filename)) {
        emit filenameChanged(filename);
    }
}

#ifndef GABRECORDER_H
#define GABRECORDER_H

#include <QObject>
#include <QAudioRecorder>
#include <QtQml>


class GabRecorder : public QObject
{
    Q_OBJECT
public:
    GabRecorder();
    ~GabRecorder();
    Q_PROPERTY(QString codec READ codec WRITE setCodec NOTIFY codecChanged)
    Q_PROPERTY(QUrl output READ output)
    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged)

    QString codec() const;
    void setCodec(const QString & codec);

    QUrl output() const;

    QString filename() const;
    void setFilename(const QString & filename);

public slots:
    void record();
    void stop();

signals:
    void codecChanged(QString codec);
    void filenameChanged(QString filename);

private:
    QAudioRecorder m_recorder;
    QAudioEncoderSettings m_audioSettings;
    QString m_output;

    bool setOutput(const QString &filename);
};

#endif // GABRECORDER_H

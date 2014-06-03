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

    Q_PROPERTY(QString tmp READ tmp WRITE setTmp NOTIFY tmpChanged)

    QString tmp() const;
    void setTmp(const QString &t);

public slots:
    void record();

signals:
    void tmpChanged(QString tmp);

private:
    QAudioRecorder m_recorder;
    QString m_tmp;
};

#endif // GABRECORDER_H

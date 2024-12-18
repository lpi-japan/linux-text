# プロセス管理
Linuxのシステムは、様々なプログラムが動作して構成されています。動作しているプログラムをLinuxは「プロセス」として扱います。

本章では、プロセスの確認や管理について解説します。

本章の内容

- プロセスとは
- top コマンド
- シグナルによるプロセスの制御

## プロセスとは
Linuxでは実行中のプログラム（アプリケーション）を「プロセス」として扱います。

コマンドを実行するために使っているシェル自身もプロセスです。シェルからコマンドを実行すると、プログラムが起動されてプロセスとなり、Linuxカーネルが管理します。プログラムが終了すると、プロセスは無くなります。

プロセスがプロセスを生成する場合、生成した側を親プロセス、生成された側を子プロセスと呼びます。シェルからコマンドを実行する場合、シェルが親プロセス、コマンドが子プロセスとなります。

### psコマンドでプロセスを確認する
動作しているプロセスを確認するには、psコマンドを使います。psコマンドはオプションをつけることで様々なプロセスの情報を表示できます。

```
書式
ps [オプション]

オプション
a
すべてのプロセスを表示する

f
プロセスの親子関係を表示する

u
実行ユーザーを表示する

x
制御端末のないバックグラウンドプロセスも表示する
```

psコマンドを、オプション無しで実行します。

```
$ ps
    PID TTY          TIME CMD
   3306 pts/1    00:00:00 bash
   3356 pts/1    00:00:00 ps
```

現在使用しているシェルとpsコマンドのみ表示されます。

### プロセスの親子関係を確認する
fオプションをつけて実行します。プロセスの親子関係が表示されます。

```
$ ps f
    PID TTY      STAT   TIME COMMAND
   2618 pts/0    Ss+    0:00 bash
   3362 pts/0    R+     0:00  \_ ps f
   1816 tty2     Ssl+   0:00 /usr/libexec/gdm-wayland-session --register-session
   1823 tty2     Sl+    0:00  \_ /usr/libexec/gnome-session-binary
```

psコマンドのプロセスがシェルから起動された子プロセスであることがわかります。また、GUI環境を利用するために必要なプロセスが別に動作しているのがわかります。

### プロセスを実行したユーザーを確認する
uオプションをつけて実行します。プロセスを実行したユーザーの情報が表示されます。

```
$ ps u
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
linuc       1816  0.0  0.4 375108  7644 tty2     Ssl+ 10:30   0:00 /usr/libexec/
linuc       1823  0.0  1.0 518668 17776 tty2     Sl+  10:30   0:00 /usr/libexec/
linuc       2618  0.0  0.3 223940  5120 pts/0    Ss+  10:32   0:00 bash
linuc       3368  0.0  0.1 225488  3072 pts/0    R+   15:03   0:00 ps u
```

ユーザーlinucがプロセスを実行していることがわかります。

### バックグラウンド動作しているプロセスを確認する
シェルから起動したプロセス以外に、様々なプロセスが動作してLinuxのシステムを構成しています。それらのプロセスもpsコマンドで確認できます。

psコマンドをxオプションをつけて実行します。制御端末のないバックグラウンドで動作しているプロセスの情報も表示されます。

```
$ ps x
    PID TTY      STAT   TIME COMMAND
   1786 ?        Ss     0:00 /usr/lib/systemd/systemd --user
   1788 ?        S      0:00 (sd-pam)
   1807 ?        Sl     0:00 /usr/bin/gnome-keyring-daemon --daemonize --login
   1816 tty2     Ssl+   0:00 /usr/libexec/gdm-wayland-session --register-session
（略）
   2618 pts/0    Ss+    0:00 bash
   3369 pts/0    R+     0:00 ps x
```

2番目のTTYの列が制御端末を表しています。この項目が?になっているプロセスは制御端末が無いので、バックグラウンドで動作しています。

### 制御端末のあるすべてのプロセスを確認する
Linuxのシステム全体のプロセスを確認するには、aオプションをつけて実行します。制御端末のあるすべてのプロセスの情報が表示されます。

```
$ ps a
    PID TTY      STAT   TIME COMMAND
   1816 tty2     Ssl+   0:00 /usr/libexec/gdm-wayland-session --register-session
   1823 tty2     Sl+    0:00 /usr/libexec/gnome-session-binary
   2618 pts/0    Ss+    0:00 bash
   3376 pts/0    R+     0:00 ps a
```

GUIのためのプロセスが動作しているのがわかります。

### すべてのプロセスを確認する
axオプションをつけて実行します。制御端末のないバックグラウンドで動作しているプロセスもすべて表示されます。

```
$ ps ax
    PID TTY      STAT   TIME COMMAND
      1 ?        Ss     0:00 /usr/lib/systemd/systemd rhgb --switched-root --sys
      2 ?        S      0:00 [kthreadd]
（略）
```

カーネル起動後に最初に起動されるプロセスがプロセスID1番となりますが、systemdが最初に起動しているのがわかります。

### pstreeコマンド
プロセスの親子関係をツリー表示するには、pstreeコマンドを使います。ps fコマンドでも親子関係は表示できますが、より見やすい表示が行えます。

```
$ pstree
systemd─┬─ModemManager───3*[{ModemManager}]
        ├─NetworkManager───2*[{NetworkManager}]
（略）
```

## top コマンド
プロセスの状態を確認するツールとして、topコマンドがあります。

topコマンドは実行中のプロセスの状態をリアルタイムで表示します。プロセスをCPUやメモリの使用率でソートしたり、システム全体のリソース負荷を確認できます。

topコマンドのキー操作

| キー | 動作
|-|-
| ? | ヘルプを表示する
| スペース | 表示を更新する
| 1 | CPU別にCPUの使用率を表示する
| P | CPU使用率でプロセスをソート
| M | メモリ使用率でプロセスをソート
| < > | ソートのための項目を左右に選択する
| x | ソートのために選択している項目をハイライト
| b| ソートのために選択している項目を分かりやすくする
| q| 終了する

topコマンドを実行して、各キー操作の動作を確認してみてください。

```
$ top
```

「b」で選択している項目を分かりやすくする動作だけは、先に「x」で選択をハイライトにしてからでないと動作が分かりにくくなっています。「xb」と入力してみてください。

## シグナルによるプロセスの制御
プロセスは処理が正常に終わって終了したり、エラーを起こして異常終了する他、外部からシグナルを送ることで処理を停止させたり、終了させたりすることができます。

コマンドラインでプロセスにシグナルを送信する方法は2つあります。

- 端末でキー入力（例：Ctrl+cやCtrl+zなど）
- killコマンド

### シグナル番号とシグナル名
シグナルには、シグナル番号およびシグナル名が割り当てられており、代表的なものに以下のシグナルがあります。

代表的なシグナル

| シグナル番号 | シグナル名 | 意味 | キー入力
|-|-
| 1 | HUP | ハングアップ(Hang Up) |
| 2 | INT | 割り込み(Interrupt) | Ctrl+c
| 9 | KILL | 強制終了(Kill) |
| 15 | TERM | 終了(Terminate)。killコマンドのデフォルトシグナル |
| 18 | TSTP | 一時停止(Terminate) | Ctrl+z

上記以外にもシグナルがあり、killコマンドに-lオプションをつけて実行することでシグナルの種類を表示することができます。

```
$ kill -l
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL
 5) SIGTRAP	 6) SIGABRT	 7) SIGEMT	 8) SIGFPE
 9) SIGKILL	10) SIGBUS	11) SIGSEGV	12) SIGSYS
13) SIGPIPE	14) SIGALRM	15) SIGTERM	16) SIGURG
17) SIGSTOP	18) SIGTSTP	19) SIGCONT	20) SIGCHLD
21) SIGTTIN	22) SIGTTOU	23) SIGIO	24) SIGXCPU
25) SIGXFSZ	26) SIGVTALRM	27) SIGPROF	28) SIGWINCH
29) SIGINFO	30) SIGUSR1	31) SIGUSR2
```

### killコマンドによるシグナル送信
killコマンドでプロセスにシグナルを送信してみます。

```
書式
kill [オプション] プロセスID

オプション
-シグナル番号
指定したシグナル番号のシグナルをプロセスに送信する
```

以下の実行例では、実行中のプロセスにkillコマンドでシグナルを送信して、プロセスを終了しています。

```
$ sudo tail -f /var/log/messages &
[1] 22385
（略）
$ kill 22385
$ ※メッセージが表示されるようにEnterキーを入力
[1]+  Terminated              sudo tail -f /var/log/messages
```

&をつけてコマンドを実行すると、そのコマンドはバックグラウンドジョブとしてプロセスが実行されたままになり、制御はコマンドプロンプトに戻ります。tail -fコマンドは終了の指示を受けない限り引数で指定されたファイルに書き込まれた情報を標準出力に表示し続けます。

シェルプロンプトに戻った際に表示されているのが、ジョブ番号とプロセスIDです。killコマンドの引数としてこのプロセスIDを指定することでプロセスが終了しました。

### シグナル指定の使い方
オプションでシグナルを指定しない場合、デフォルトで15番のTERM（SIGTERM）が送信されます。プログラムが暴走してしまい制御できなくなったプロセスを強制的に終了するためにシグナル番号9番（KILL）を送信するなどの使い方をします。

\pagebreak


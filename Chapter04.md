# Linuxを操作してみよう
Linuxのインストールが終わったら、コマンド操作などについて学んで行く前に、簡単に操作をしてみましょう。

本章では、ログインからコマンド実行、Webサーバーを動かすための手順と、実習を行いやすくするためのSSHによるリモートログインについて解説します。

本章の内容

- GUIによるログインとログアウト
- コマンド実行のための端末を起動
- Webサーバーを動かしてみる
- SSHでリモートログインする


## GUIによるログインとログアウト
Linuxを使い始めるにはログインを、使い終わったらログアウトを行います。

システムが起動したら、ログインとログアウトを試してみましょう。

### GUIでログインする
ログインするには、ログインしたいユーザーをクリックし、パスワードを入力します。

![ログインの画面](image/Ch04/Login.png){width=70%}

\pagebreak

### 初回ログイン時のツアー
初回ログイン時には「AlmaLinuxへようこそ」と表示され、操作方法を確認するツアーを開始できます。ツアーを見たい場合には「ツアーをチェックする」ボタンをクリックします。はじめてAlmaLinuxのGUIを操作するのであれば、短いツアーですのでチェックしてみてください。

![AlmaLinuxへようこその画面](image/Ch04/WelcomeAlmaLinux.png){width=70%}

### GUIでログアウトする方法
ログアウトするには、画面右上にあるメニューバーの電源アイコンをクリックし、「電源オフ/ログアウト」をクリックすると表示される「ログアウト」をクリックします。

ログアウトを確認するダイアログが表示されるので、「ログアウト」をクリックします。

\pagebreak

## コマンド実行のための端末を起動
コマンドを実行してLinuxを操作するために「端末」アプリを起動します。

再度ログインを行い、画面左上の「アクティビティ」をクリックし、画面下に表示されるアイコンから「端末」アプリのアイコンをクリックします。

![端末起動の画面](image/Ch04/Terminal.png){width=70%}

## Webサーバーを動かしてみる
Linuxでは、コマンドを実行して各種サービスの起動や停止を行います。ここでは、OSインストール時に追加で導入したWebサーバーを起動して、Webブラウザからアクセスしてみます。

### Webサーバーを起動する
Webサーバーを起動します。Webサーバーは、AlmaLinuxではhttpdサービスと呼ばれています。サービスの起動や停止はsystemctlコマンドを実行して行います。

Webサーバーのようなサービスは、実行するためにはLinuxのシステム管理者のユーザー権限が必要になります。システム管理者やユーザー権限については第7章で解説します。

「端末」アプリのコマンドプロンプトで、systemctlコマンドを実行します。

```
$ systemctl start httpd
```

systemctlコマンドを実行すると、システム管理者のユーザー権限があることを確認するためにユーザーlinucのパスワードを要求するダイアログが表示されるので、パスワードを入力します。OSインストール時の「ユーザーの作成」でユーザーlinucを作成する際に「このユーザーを管理者にする」をチェックしているので、ユーザーlinucのパスワードを入力することでシステム管理者のユーザー権限があることを確認できます。

### Webサーバー起動の確認とコマンド履歴
認証に成功すると、httpdサービスが起動します。実行結果が何も表示されていないので、起動されたことを確認するため、systemctl statusコマンドを実行します。

コマンドプロンプトには、コマンド履歴という機能があります。以前に実行したコマンドを呼び出してそのまま実行したり、修正して実行したりできます。カーソルキーの上下でコマンド履歴を呼び出し、修正する場合にはカーソルキーの左右でカーソルを動かし、DeleteキーやBackSpaceキーで文字を消すことができます。

\pagebreak

カーソルキーの上を押して「systemctl start httpd」コマンドを呼び出し、「start」を消して「status」に書き換えて実行します。

```
$ systemctl start httpd
```
↓ カーソルを左に移動してrtを削除
```
$ systemctl sta httpd
```
↓ tusを追加して実行
```
$ systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; preset: d>
     Active: active (running) since Mon 2024-10-21 16:46:51 JST; 1s ago
       Docs: man:httpd.service(8)
   Main PID: 8248 (httpd)
     Status: "Started, listening on: port 443, port 80"
      Tasks: 178 (limit: 10104)
     Memory: 32.5M
        CPU: 34ms
     CGroup: /system.slice/httpd.service
             ├─8248 /usr/sbin/httpd -DFOREGROUND
             ├─8249 /usr/sbin/httpd -DFOREGROUND
             ├─8250 /usr/sbin/httpd -DFOREGROUND
             ├─8251 /usr/sbin/httpd -DFOREGROUND
             ├─8252 /usr/sbin/httpd -DFOREGROUND
             └─8253 /usr/sbin/httpd -DFOREGROUND

10月 21 16:46:51 localhost.localdomain systemd[1]: Starting The Apache HTTP Ser>
10月 21 16:46:51 localhost.localdomain httpd[8248]: AH00558: httpd: Could not r>
10月 21 16:46:51 localhost.localdomain systemd[1]: Started The Apache HTTP Serv>
10月 21 16:46:51 localhost.localdomain httpd[8248]: Server configured, listenin>
```

実行結果の「Active:」の項目が「active (running)」になっていれば、httpdサービスが実行中であることがわかります。サービスはいくつかのプロセスとしてバックグラウンドで実行されています。プロセスについては第10章で解説します。確認を終えたら「q」（Quit）キーを入力して表示を終了します。

\pagebreak

### WebブラウザでWebサーバーにアクセスする
Webブラウザを起動して、Webサーバーにアクセスしてみます。

画面左上の「アクティビティ」をクリックし、画面下に表示されるアイコンから一番左にある「Firefox」アプリのアイコンをクリックします。

Webブラウザのウインドウが表示されたら、アドレスに「localhost」と入力して、Enterキーを押します。「AlmaLinux Test Page」が表示されたら、Webサーバーにアクセスできたことが確認できます。

![テストページ画面](image/Ch04/TestPage.png){width=70%}

### Webサーバーを停止してみる
Webサーバーを停止してみます。

コマンドプロンプトで、systemctl stopコマンドを実行します。コマンド履歴とコマンドライン編集を使って実行してみてください。

```
$ systemctl stop httpd
```

再度、ユーザーlinucのパスワード認証が要求されるので、パスワードを入力します。再度systemctl statusコマンドで確認すると、「Active:」の項目が「inactive (dead)」になっています。Webブラウザで再読み込みを行うと「正常に接続できませんでした」と表示されます。

再度、systemctl startコマンドで起動し直して、正常な状態に戻るのも確認してみてください。

\pagebreak

## SSHでリモートログインする
Linuxが動作しているマシンが手元にある場合にはGUIで直接ログインできますが、多くの場合Linuxが動作するマシンはデータセンターやマシンルームの中に設置されていたり、クラウド上で動作しています。このようにリモートにあるLinuxを操作するには、SSHでリモートログインする必要があります。

本教科書の実習は基本的にGUIで直接ログインし、「端末」アプリのコマンドプロンプトで進めることができますが、リモート操作に慣れるためにホストOSからゲストOSにSSHでリモートログインしてみることをお勧めします。

### LinuxのIPアドレスを調べる
事前にLinuxでipコマンドを実行して、ログイン先のIPアドレスを調べてみます。

「端末」アプリのウインドウ内にコマンドプロンプトが表示されているので、コマンドを入力し、Enterキーを押して実行します。「ip a」コマンドは、実行したマシンに割り当てられているIPアドレスなどの情報を表示します。

```
$ ip a
```

![ipコマンド実行画面](image/Ch04/ipa.png){width=70%}

実行した仮想マシンには、ネットワークアダプターを2つ設定しています。自分自身に接続する「ローカルループバック」を含めて、3つのネットワークインターフェースの情報が表示されます。IPアドレスは「inet」で始まる行に記述されています。

```
$ ip a
（略）
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a2:d5:45 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.3/24 brd 192.168.56.255 scope global dynamic noprefixroute enp0s8
（略）
```

「192.168.56.x/24」はホストオンリーネットワークに設定したアダプターのIPアドレスです。DHCPで動的に割り当てられるため、第4オクテットは変わる場合があります。

ホストOSとゲストOSを接続するにはホストオンリーネットワークを経由する必要があります。SSHのログイン先のIPアドレスはこの「192.168.56.x」になります。

\pagebreak

### WindowsからSSHを行う方法
Windowsから仮想マシン上で動作するLinuxにSSHでリモートログインするには、Windows側でSSHクライアントを実行する必要があります。方法としては、以下の2つの方法があります。

- WindowsでコマンドプロンプトやPowerShellを実行し、sshコマンドを実行する
- Tera TermなどのSSHプロトコルをサポートしたソフトウェアを導入する

今回はWindowsの標準機能であるsshコマンドを使ってみます。

### Windowsのコマンドプロンプトを実行する
Windowsのコマンドプロンプトを実行します。タスクバーの検索ウインドウに「cmd」と入力し、候補として出てきた「コマンドプロンプト」を実行します。

タスクバーに検索ウインドウが無い場合には、タスクバーを右クリックして「タスクバーの設定」から、検索ウインドウを表示するように設定してください。

### sshコマンドでゲストOSに接続する
コマンドプロンプトでsshコマンドを実行して、ゲストOSのLinuxに接続します。

```
書式
ssh ユーザー名@接続先IPアドレス
```

以下の例では、ユーザーlinucで192.168.56.3に接続しようとしています。

```
>ssh linuc@192.168.56.3
The authenticity of host '192.168.56.3 (192.168.56.3)' can't be established.
ECDSA key fingerprint is SHA256:/yjso78Rqa2Sv+UWJ/k8ofOrrT0dFWdX2+Efyuef8qY.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes ※yesと入力
Warning: Permanently added '192.168.56.3' (ECDSA) to the list of known hosts.
linuc@192.168.56.3's password: ※ユーザーlinucのパスワードを入力（非表示）
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Thu Oct 17 17:22:16 2024 from 192.168.56.1
[linuc@vbox ~]$
```

![リモートログイン画面](image/Ch04/ssh.png){width=70%}

初めてSSHで接続する場合、接続先のホスト証明書が送られてきます。接続を続ける場合には「yes」と入力します。その後、ユーザーlinucのパスワードが要求されるので、パスワードを入力すると接続が完了します。

コマンドプロンプトが表示されれば、GUIの「端末」アプリで実行するのと同じようにコマンドを実行できます。
\pagebreak


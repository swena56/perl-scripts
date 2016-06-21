#enviromentSetup
echo 'set completion-ignore-case On' >> ~/.inputrc

sudo add-apt-repository -y ppa:webupd8team/sublime-text-2
sudo apt-get install sublime-text git perltidy perl-doc cpanminus, mysql-server

subl # so the packages directory of sublime can get initalized
cd .config/sublime-text-2/Packages
echo '{ "cmd": ["perl", "-w", "$file"], "file_regex": ".* at (.) line ([0-9])", "selector": "source.perl" }' > Perl/Perl.sublime-build
git clone https://github.com/wbond/sublime_alignment
git clone https://github.com/SublimeCodeIntel/SublimeCodeIntel
git clone https://github.com/SublimeLinter/SublimeLinter-for-ST2
git clone https://github.com/kemayo/sublime-text-git
git clone https://github.com/cockscomb/SublimePerldoc

git clone https://github.com/tushortz/Perl-Completions
git clone https://github.com/vifo/SublimePerlTidy PerlTidy

#mysql create user
#CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
#GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';
#FLUSH PRIVILEGES;
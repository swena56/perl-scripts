sudo apt-get update
sudo apt-get install sublime-text git perltidy perl-doc subversion postgresql wget apache2 cpanminus
sudo cpanm FindBin Moose DBI DBD::mysql Data::Faker 

add /tmp/** rwk to /etc/apparmor.d/usr.sbin.mysqld

#set up workspaces its not enabled by default in Ubuntu

#bash incasesenstive tab comeplete
echo 'set completion-ignore-case On' >> ~/.inputrc

sudo add-apt-repository -y ppa:webupd8team/sublime-text-2


#install skype


subl # so the packages directory can get initalized
cd .config/sublime-text-2/Packages
echo '{ "cmd": ["perl", "-w", "$file"], "file_regex": ".* at (.) line ([0-9])", "selector": "source.perl" }' > Perl/Perl.sublime-build
git clone https://github.com/wbond/sublime_alignment
git clone https://github.com/SublimeCodeIntel/SublimeCodeIntel
git clone https://github.com/SublimeLinter/SublimeLinter-for-ST2
git clone https://github.com/kemayo/sublime-text-git
git clone https://github.com/cockscomb/SublimePerldoc

git clone https://github.com/tushortz/Perl-Completions
git clone https://github.com/vifo/SublimePerlTidy PerlTidy



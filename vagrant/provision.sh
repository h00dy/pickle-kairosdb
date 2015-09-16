# Install essential packages
apt-get update
apt-get upgrade
apt-get -y install mc vim git 2> /dev/null
apt-get -y install build-essential libbz2-dev libfreetype6-dev libgdbm-dev python3-dev 2> /dev/null
apt-get -y install python3-pip 2> /dev/null

# Configure date
echo 'Europe/Warsaw' > /etc/timezone
ntpdate-debian

# Create virtualenv for python 3.4
pip3 install virtualenvwrapper
VIRTUALENVS='/home/vagrant/.virtualenvs'
HOME_DIR='/home/vagrant'
if [ ! -d $VIRTUALENVS ]; then
mkdir $HOME_DIR/.virtualenvs
fi
chown -R vagrant:vagrant $VIRTUALENVS
sudo -u vagrant bash -c "export WORKON_HOME=$VIRTUALENVS"
if [ `grep pickle-kairos $HOME_DIR/.bashrc | wc -l` = 0 ]; then
echo "VIRTUALENVWRAPPER_PYTHON='/usr/bin/python3'" >> $HOME_DIR/.bashrc
echo 'command' >> $HOME_DIR/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> $HOME_DIR/.bashrc
echo 'if [ `workon | grep pickle-kairos | wc -l` = 1 ]' >> $HOME_DIR/.bashrc
echo 'then' >> $HOME_DIR/.bashrc
echo 'workon pickle-kairos' >> $HOME_DIR/.bashrc
echo 'else' >> $HOME_DIR/.bashrc
echo 'mkvirtualenv pickle-kairos' >> $HOME_DIR/.bashrc
echo "$HOME_DIR/.virtualenvs/pickle-kairos/bin/pip install -r $HOME_DIR/project/requirements.txt" >> $HOME_DIR/.bashrc
echo 'fi' >> $HOME_DIR/.bashrc
fi

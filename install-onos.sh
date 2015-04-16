# Install script for ONOS VMs

# Sort out hostname
sudo sed -i /etc/hosts -e '/^127.0.0.1 localhost/ s/$/ localhost.localdomain/'
sudo bash -c "echo '127.0.1.1 $(hostname)' >> /etc/hosts"

# Setup the extra interface in order to be able to interact with the multicasting that ONOS uses
while true; do
    read -p "Please enter your test network IP:" ip
    case $ip in
	* ) sudo ifconfig eth1 $ip; break;;
    esac
done

# Setup user sdn
sudo useradd sdn -m -p sdn -s /bin/bash
sudo passwd sdn

# Setup ssh kyes
sudo cp -r ~/.ssh/ /home/sdn/
sudo chown -R sdn:sdn /home/sdn/.ssh/

# Add sdn to the sudoers file
sudo bash -c "echo 'sdn ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/sdn; chmod 440 /etc/sudoers.d/sdn"

#sudo chown 0 /etc/sudoers.d/sdn

# Install Java PPA

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y dist-upgrade

# Install Java 8

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default

# Install maven

wget http://mirror.ox.ac.uk/sites/rsync.apache.org/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
sudo tar xzf apache-maven-3.2.5-bin.tar.gz -C /usr/local

# Create symbolic links for all these maven files to avoid adjusting the .profile
sudo ln -s /usr/local/apache-maven-3.2.5/bin/mvn /usr/local/bin/
sudo ln -s /usr/local/apache-maven-3.2.5/bin/m2.conf /usr/local/bin/
sudo ln -s /usr/local/apache-maven-3.2.5/bin/mvnyjp /usr/local/bin/
sudo ln -s /usr/local/apache-maven-3.2.5/bin/mvnDebug /usr/local/bin/

# Install wireshark
sudo apt-get -y install bison flex libqt4-dev libgtk-3-dev libpcap-dev zlib1g-dev libssl-dev
wget https://www.wireshark.org/download/src/wireshark-1.12.4.tar.bz2
sudo tar -jxvf wireshark-1.12.4.tar.bz2 -C /usr/local
cd /usr/local/wireshark-1.12.4/
sudo ./configure --with-ssl
make &
sudo make install

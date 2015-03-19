
# install Java PPA

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y dist-upgrade

# install Java 7

echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install oracle-java7-installer
sudo apt-get install oracle-java7-set-default


# install maven

wget http://mirror.ox.ac.uk/sites/rsync.apache.org/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
sudo tar xzf apache-maven-3.2.5-bin.tar.gz -C /usr/local
echo 'PATH="/usr/local/apache-maven-3.2.5/bin:$PATH"' >> ~/.profile
source ~/.profile

# install Java 8

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default


# install karaf

wget http://www.eu.apache.org/dist/karaf/3.0.2/apache-karaf-3.0.2.tar.gz
tar xzf apache-karaf-3.0.2.tar.gz -C ~
ln -s ~/apache-karaf-3.0.2 ~/karaf
echo 'export KARAF_ROOT=~/apache-karaf-3.0.2' >> ~/.profile
echo 'PATH="$KARAF_ROOT/bin:$PATH"' >> ~/.profile

# install ONOS

sudo apt-get -y install git
git clone https://gerrit.onosproject.org/onos -b 1.0.0 ; cd onos
mvn clean install



###################################


echo 'export ONOS_ROOT=~/onos' >> ~/.profile
echo 'source $ONOS_ROOT/tools/dev/bash_profile' >> ~/.profile

source ~/.profile
cp ${ONOS_ROOT}/tools/package/branding/target/onos-branding-1.0.0.jar ${KARAF_ROOT}/lib/
sed -i $KARAF_ROOT/etc/org.apache.karaf.features.cfg -e '/^featuresRepositories=/ s/$/,mvn:org.onosproject\/onos-features\/1.0.0\/xml\/features/'
sed -i $KARAF_ROOT/etc/org.apache.karaf.features.cfg -e '/^featuresBoot=/ s/$/,onos-api,onos-core-trivial,onos-cli,onos-openflow,onos-app-fwd,onos-app-mobility,onos-gui/'

#Alias
alias dm docker-machine
alias efuncs "edit $OMF_CONFIG/init.fish"
alias rc rancher-compose

#Funcs
function dcf -d "Do docker compose in Documents/Docker"
  if test (count $argv) -lt 2
      echo "Usage: dcf <docker-compose-name> <command>"
      docker-compose
  else
    if test -f ~/Documents/Docker/compose/$argv[1]/docker-compose.yml
      docker-compose -f ~/Documents/Docker/compose/$argv[1]/docker-compose.yml $argv[2..-1]
    else
      echo "Not Fonud The Docker-Compose File!!"
    end
  end
end

function ssr -d "Alias for ssh root@"
  ssh -l root $argv
end

function chnor -d "change to normal hosts"
  sudo sed -i '' -e "/"(docker-machine ip default)"/d" /etc/hosts
end

function chdev -d "Change to develop hosts"
  chnor
  sudo sed -e "s/^/"(docker-machine ip default)" /g" /etc/hosts.dev >> /etc/hosts
end

function ehdev -d "edit the develop hosts"
  edit /etc/hosts.dev
end

function ehnor -d "edit the system hosts"
  edit /etc/hosts
end

function lhdev -d "list the /etc/hosts.dev"
  cat /etc/hosts.dev
end

function lhnor -d "list the /etc/hosts"
  cat /etc/hosts
end

function nopass -d "Auto config the ssh key to remote server"
  if test -z $argv
      echo "Usage: nopass user@domain"
  else
      if test -f ~/.ssh/id_rsa.pub
          echo "Local RSA Certs Found!"
      else
          echo "Not Fonud Local RSA Certs , Generate..."
          ssh-keygen -t rsa -q -f ~/.ssh/id_rsa -N ''
      end
      set key (cat ~/.ssh/id_rsa.pub)
      ssh $argv "mkdir ~/.ssh;echo $key >> ~/.ssh/authorized_keys;chmod 640 ~/.ssh/authorized_keys;chmod 740 ~/.ssh"
  end
end

function edit -d "sublime cli command"
  /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl $argv
end

function dme -d "Set Docker Machine Env"
  eval (docker-machine env $argv)
  env | grep "DOCKER"
end

function dins-local -d "Create xhyve Docker Machine"
  if test (count $argv) -eq 0
    docker-machine create --driver virtualbox --virtualbox-cpu-count "2" --virtualbox-memory 4096 --virtualbox-disk-size 20000 --engine-registry-mirror https://q1iq1clk.mirror.aliyuncs.com --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso default
  else if test (count $argv) -eq 1
    docker-machine create --driver virtualbox --virtualbox-cpu-count "2" --virtualbox-memory 2048 --engine-registry-mirror https://q1iq1clk.mirror.aliyuncs.com --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso $argv[1]
  else
    docker-machine create --driver virtualbox --engine-registry-mirror https://q1iq1clk.mirror.aliyuncs.com --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso $argv
  end
  docker-machine ls
end

function rce -d "Set Rancher-Compose Env"
  cd ~/Documents/Docker/rancher-$argv[1]
  source ~/Documents/Docker/rancher-$argv[1]/envirment
  env | grep "RANCHER"
end

function rcc -d "Create A new sample Env"
  if test -d ~/Documents/Docker/rancher-$argv[1]
    echo "The Rancher Env Already Exists"
  else
    mkdir ~/Documents/Docker/rancher-$argv[1]
    echo "export RANCHER_URL='RANCHER_URL'" > ~/Documents/Docker/rancher-$argv[1]/envirment
    echo "export RANCHER_ACCESS_KEY='RANCHER_ACCESS_KEY'" >> ~/Documents/Docker/rancher-$argv[1]/envirment
    echo "export RANCHER_SECRET_KEY='RANCHER_SECRET_KEY'" >> ~/Documents/Docker/rancher-$argv[1]/envirment
    edit ~/Documents/Docker/rancher-$argv[1]/envirment
  end
end

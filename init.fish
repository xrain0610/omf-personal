#Alias
alias dm docker-machine
alias efuncs "edit $OMF_CONFIG/init.fish"

#Funcs
function dcf -d "Do docker compose in Documents/Docker"
  if test (count $argv) -lt 2
      echo "Usage: dcf <docker-compose-name> <command>"
      docker-compose
  else
    if test -f ~/Documents/Docker/$argv[1].yml
      docker-compose -f ~/Documents/Docker/$argv[1].yml $argv[2..-1]
    else
      echo "Not Fonud The Docker-Compose File!!"
    end
  end
end

function gojms
  ssh -t -p9899 work@114.112.169.2 ssh work@10.10.15.5
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

function dme
  eval (docker-machine env $argv)
  env | grep "DOCKER"
end

function dins-local
  if test (count $argv) -eq 0
    docker-machine create --driver xhyve --xhyve-cpu-count "2" --xhyve-memory-size 4096 --xhyve-disk-size 20000 --xhyve-experimental-nfs-share --engine-registry-mirror https://q1iq1clk.mirror.aliyuncs.com default
  else if test (count $argv) -eq 1
    docker-machine create --driver xhyve --xhyve-cpu-count "1" --xhyve-memory-size 1024 --xhyve-disk-size 10000 --xhyve-experimental-nfs-share --engine-registry-mirror https://q1iq1clk.mirror.aliyuncs.com $argv[1]
  else
    docker-machine create --driver xhyve --engine-registry-mirror https://q1iq1clk.mirror.aliyuncs.com $argv
  end
  docker-machine ls
end

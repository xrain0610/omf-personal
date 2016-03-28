#Alias
alias dm docker-machine
alias dcf "cd ~/Documents/Docker;docker-compose -f"
alias ssr "ssh -l root "
alias ehdev "edit /etc/hosts.dev"
alias ehnor "edit /etc/hosts"
alias lhdev "cat /etc/hosts.dev"
alias lhnor "cat /etc/hosts"
alias efuncs "edit $OMF_CONFIG/init.fish"

#Funcs
function chnor
  sudo sed -i '' -e "/"(docker-machine ip default)"/d" /etc/hosts
end

function chdev
  chnor
  sudo sed -e "s/^/"(docker-machine ip default)" /g" /etc/hosts.dev >> /etc/hosts
end

function nopass
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

function edit
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

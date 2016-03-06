#Alias
alias dm docker-machine
alias ssr "ssh -l root "
alias chdev "sudo sed -i '' -e '/192.168.64..*/d' /etc/hosts;cat /etc/hosts.dev >> /etc/hosts"
alias chnor "sudo sed -i '' -e '/192.168.64..*/d' /etc/hosts"
alias ehdev "edit /etc/hosts.dev"
alias ehnor "edit /etc/hosts"
alias lhdev "cat /etc/hosts.dev"
alias lhnor "cat /etc/hosts"
alias ahdev "echo (docker-machine ip default) $1 >> /etc/hosts.dev"
alias ahnor "echo $1 $2 >> /etc/hosts"
alias efuncs "edit $OMF_CONFIG/init.fish"

#Funcs
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

function dins-ubuntu
    f test -z $argv
        echo "Usage: dins-ubuntu domain"
    else
        ssh root@$argv[1] "apt-get update && apt-get install curl && curl -sSL https://get.docker.com/ | sh"
    end
end

function dts-ubuntu
    if test -z $argv
        echo "Usage: dts-ubuntu domain [:mirror(*aliyun|alauda)]"
    else
        if test (count $argv) -ge 2
            switch $argv[2];
              case alauda;
                set mirror "--registry-mirror=http://xrain0610.m.alauda.cn"
              case '*';
                set mirror "--registry-mirror=https://q1iq1clk.mirror.aliyuncs.com"
            end
        end
        ruby $OMF_CONFIG/certgen.rb $argv[1]
        rsync -ave ssh ~/.docker/$argv[1]/ root@$argv[1]:~/.docker/
        ssh root@$argv[1] "echo 'DOCKER_OPTS=\"--tlsverify -H=unix:///var/run/docker.sock -H=0.0.0.0:65535 --tlscacert=/root/.docker/ca.pem --tlscert=/root/.docker/cert.pem --tlskey=/root/.docker/key.pem $mirror\"' > /etc/default/docker && service docker restart"
        drc $argv[1]
    end
end

function drc
    if test -z $argv
        echo "Usage: drc remote.docker.domain [:remote port]"
    else
        if test (count $argv) -ge 2
            set port $argv[2]
        else
            set port 65535
        end
        set -gx DOCKER_TLS_VERIFY "1";
        set -gx DOCKER_HOST tcp://$argv[1]:$port;
        set -gx DOCKER_CERT_PATH /Users/xRain/.docker/$argv[1];
        env | grep "DOCKER"
    end
end

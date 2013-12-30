# TODO:
# - huawei modem autostart
# - hardware repository for laptop stuff like wifi firmware
#   rhepel.org
# - NetworkManager i.s.o. network


# Function to move all files owned by one id to a new id.
# Should work as
function change_all_files {
    if [[ $1 = "gid" ]] ; then
       type="group"
       chcmd="chgrp -h $3"
       modcmd="groupmod -g $3 $4"
    else
       type="user"
       chcmd="chown -h $3"
       modcmd="usermod -u $3 -g $3 $4"
    fi
    echo "A Linux $type '$4' exists on the system with a different $1 ($2) than required for wos_install ($3)."
    procs=`find /proc -$1 $2 2>/dev/null | wc -l`
    if [[ $procs != 0 ]] ; then
      echo "--------------------------------------------------------------------------------------------------"
      echo "WARNING: Some processes are stull running as this user."
      echo "Please make sure all processes for this user are stopped before running the file change."
      echo "--------------------------------------------------------------------------------------------------"
    fi
    read -p "Should I globally replace all files of $1 $2 with $3 [y/n]" REPLACE
    [[ "X$REPLACE" = "Xy" ]] &&  find / -$1 $2 ! -wholename '/proc/*' -exec $chcmd {} \;
    $modcmd
}
# create_systemaccount <uid> <gid> <homedir> <shell>
function create_systemaccount {
        gid=`id -g $2` && [ $gid != $1 ] && change_all_files gid $gid $1 $2
        uid=`id -u $2` && [ $uid != $1 ] && change_all_files uid $uid $1 $2
    groupadd -r -g $1 $2
    useradd -r -u $1 -g $1 -d $3 -s $4 $2
    [[ $? != 0 ]] && usermod -d $3 -s $4 $2
}

# create_user <uid> <gid> [<shell>]
function create_user {
        gid=`id -g $2` && [ $gid != $1 ] && change_all_files gid $gid $1 $2
        uid=`id -u $2` && [ $uid != $1 ] && change_all_files uid $uid $1 $2
    groupadd -g $1 $2
    if [[ -z $3 ]] ; then
                useradd -u $1 -g $1 $2
        else
              useradd -u $1 -g $1 -s $3 $2
        fi
}
#create_user 508 boudewijn
#create_user 518 brook
#create_user 520 dawit
#create_user 521 bereket
#create_user 522 mahdi
#create_user 527 luke
create_user 528 sophonias
exit
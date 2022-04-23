#!/bin/bash
#AUTHOR: AlphanetEX, RAID 1 + LVM Configuration
unset madnm_cmd
unset disk_uuid[3]

madnm_cmd="#\n
y
"

Disk_counter(){
    dec=$1 #equivale a valor ascii de b
    hex=$(printf "%x\n" $dec);
    alphabet=$(printf "\x$hex");
    validator=$(val_existence $alphabet);
    echo $validator
}


Raid_creation(){
    sudo -S sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/'  <<< $madnm_cmd | sudo -S mdadm --create /dev/md0 --level=1 --raid-disks=2 /dev/xvdb /dev/xvdc >> raid1.log 2<&1
    mkfs.ext4 /dev/md0 
    mdadm --detail --scan >> /etc/mdadm/mdadm.conf
}

Lvm_creation(){
    #using /md0
    vgcreate vg_tp  /dev/md0

    lvcreate -n lv_www -L 2g vg_tp 
    lvcreate -n lv_db -L 2g vg_tp
    lvcreate -n lv_backup -L 2g vg_tp

    mkfs.ext4 /dev/vg_tp/lv_www
    mkfs.ext4 /dev/vg_tp/lv_db
    mkfs.ext4 /dev/vg_tp/lv_backup 

    #creacion de carpetas
    pushd / > /dev/null
    mkdir u01 u02 u03
    popd > /dev/null

}


Mount_Point(){
    counter=0; 
    # mount /dev/vg_tp/lv_www     /u01
    # mount /dev/vg_tp/lv_db      /u02
    # mount /dev/vg_tp/lv_backup  /u03

    while [ $counter -lt 3 ]
        do
         disk_uuid[$counter]=$(blkid | grep "mapper/vg_tp" | sed -r 's/.*([0-9a-z]{8})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{4})-([0-9a-z]{12}).*/\1-\2-\3-\4-\5/' | sed -n "$((counter +1))"p)
        ((counter ++))
    done
    
    #fstab mount point
    cat <<EOF >> /etc/fstab
UUID=${disk_uuid[0]} /u01 ext4 defaults 0 0
UUID=${disk_uuid[2]} /u02 ext4 defaults 0 0
UUID=${disk_uuid[3]} /u03 ext4 defaults 0 0
EOF
    #verifica que realmente fueron montados los volumenes
    mount -a
}


main(){

    Raid_creation
    Lvm_creation
    Mount_Point
    
    #teniendo el uuid hacer el here doc y montar 
}


main
#!/bin/bash 

export ACCESS_KEY='be86fa8a2bf44c6284f90a913babea32'
export SECRET_KEY='6e44c8426a3e4a89b2f1f820f90f07c1'
#VPC_URL for JCS Production 
export VPC_URL='https://vpc.ind-west-1.jiocloudservices.com'
#VPC_URL for JCS Staging only
#export VPC_URL='https://vpc.ind-west-1.staging.jiocloudservices.com'

allocation_id='eipalloc-f17e7834'  #change this to allocation id of your floating ip
association_id=$(echo $allocation_id | sed -e "s/.*-/eipassoc-/g")

if [ "$HOSTNAME" = ip-10-0-0-8 ] ; then  #change to current hostname
echo "in ip-10-0-0-8" 
instance_id='i-3e19962f'                 #change to instance id of current

else
echo "in ip-10-0-0-14" 			
instance_id='i-b3490f37'		#change to the backup ELB instance id

fi

/usr/bin/jcs vpc disassociate-address --association-id $association_id --insecure


/usr/bin/jcs vpc describe-addresses --allocation-id $allocation_id --insecure | grep 'active\|pending'
while [ $? == 0 ]
do
    echo 'in active or pending state wait till its cleared'
    /usr/bin/jcs vpc describe-addresses --allocation-id $allocation_id --insecure | grep 'active\|pending'
done

/usr/bin/jcs vpc associate-address --allocation-id $allocation_id --instance-id $instance_id --insecure



tofu init
tofu plan
tofu apply

Created cluster:

//kubectl config
aws eks update-kubeconfig --region ap-southeast-2 --name kilinov-eks-lab

// Pod identity
Created a policy:
arn:aws:iam::759984737373:policy/kilinov-policy

create a role:
 aws iam create-role --role-name kilinov-role --assume-role-policy-document file://trust-relationship.json --description "kilinov-role"
attach policy to role:
aws iam attach-role-policy --role-name kilinov-role --policy-arn="arn:aws:iam::759984737373:policy/kilinov-policy"
create association:
 aws eks create-pod-identity-association --cluster-name kilinov-delegate --role-arn "arn:aws:iam::759984737373:role/kilinov-role" --namespace harness-delegate-ng --service-account default
 Output:
 {
    "association": {
        "clusterName": "kilinov-delegate",
        "namespace": "harness-delegate-ng",
        "serviceAccount": "default",
        "roleArn": "arn:aws:iam::759984737373:role/kilinov-role",
        "associationArn": "arn:aws:eks:ap-southeast-2:759984737373:podidentityassociation/kilinov-delegate/a-x53ymlcsxw71d6oeo",
        "associationId": "a-x53ymlcsxw71d6oeo",
        "tags": {},
        "createdAt": "2026-01-20T16:10:45.332000+11:00",
        "modifiedAt": "2026-01-20T16:10:45.332000+11:00",
        "disableSessionTags": false
    }
 }

 Add required permissions to the policy: ec2:CreateVPC etc.
 ec2:CreateLaunchTemplate
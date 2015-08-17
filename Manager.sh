#!/bin/bash

source ~/.bash_profile;

TARGETS=();
ASSET_IDS=();

TARGETS[0]=test;
ASSET_IDS[0]=284543610;

TARGETS[1]=release;
ASSET_IDS[1]=284543741;

TARGETS[2]=Fattycat17_dev;
ASSET_IDS[2]=285494479;

for index in "${!TARGETS[@]}"; do
	# Check target;
	AssetID=${ASSET_IDS[$index]};
	TargetName=${TARGETS[$index]};
	URL="http://roblox.com/studio/plugins/info?assetId=$AssetID";
	curl -L -o "asset-$TargetName" -s $URL;
	AssetVersion=$(grep -o "value=\"[0-9]*" "asset-$TargetName");
	AssetVersion=${AssetVersion:7};

	file="$TargetName.assetid";
	touch $file;
	last=$(cat $file);
	#echo "po";
	#echo $last;
	#echo $AssetVersion;
#	echo ${#last};
#	echo ${#AssetVersion};	
	if [ "$last" != $AssetVersion ];
	then
		echo "NEW VERSION FOR TARGET: $TargetName, new AssetVersionID is: $AssetVersion";
		echo $AssetVersion > $file;
		git add $file;
		git commit -m 'update';
		git push;
		#touch YES;
		lua sendmsg.lua "deployment finished: $TargetName, waiting for SYNC...";
	fi
	echo $AssetVersion $TargetName 
done

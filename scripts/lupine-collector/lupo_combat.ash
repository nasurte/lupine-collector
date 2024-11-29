


 

void main(int initround, monster foe, string page){
	matcher offenseMatcher = create_matcher("Offense: (\\d+)",page);
	matcher defenseMatcher = create_matcher("Defense: (\\d+)",page);
	matcher scoreMatcher = create_matcher("Score:(\\d+)",page);
	 
	int wolfScore;
	int wolfOffense;
	int wolfDefense;
	int aspenBlowsNeeded;
	int stoneBlowsNeeded;
	int blowsDone;
	int currentBreath;
	float aspenHouseHP;
	float stoneHouseHP;


	switch(foe){
		case $monster[Abcrusher 4000&trade;]:
		if(have_skill($skill[Gallapagosian Mating Call])&&!(get_property("_gallapagosMonster")=="Abcrusher 4000&trade;")){
			use_skill($skill[Gallapagosian Mating Call]);
		}
		if (!(item_amount($item[porquoise-handled sixgun])==0)){
			throw_item($item[porquoise-handled sixgun]);
		}
		if(have_equipped($item[everfull dart holster])||have_equipped($item[jurassic parka])){
			while(current_round()>0 && have_skill($skill[Darts: Aim for the Bullseye])) use_skill($skill[Darts: Aim for the Bullseye]);
			if(current_round()>0 && have_skill($skill[Spit jurassic acid])) use_skill($skill[Spit jurassic acid]);
			break;
		}
		if (have_skill($skill[saucegeyser])){
			use_skill($skill[saucegeyser]);
		}
		break;


		case $monster[Escalatormaster&trade;]:
		if (!(item_amount($item[porquoise-handled sixgun])==0)){
			throw_item($item[porquoise-handled sixgun]);
		}
		if(have_equipped($item[everfull dart holster])||have_equipped($item[jurassic parka])){
			while(current_round()>0 && have_skill($skill[Darts: Aim for the Bullseye])) use_skill($skill[Darts: Aim for the Bullseye]);
			if(current_round()>0 && have_skill($skill[Spit jurassic acid])) use_skill($skill[Spit jurassic acid]);
			break;
		}
		if (have_skill($skill[saucegeyser])){
			use_skill($skill[saucegeyser]);
		}
		break;


		case $monster[Legstrong&trade; stationary bicycle]:
		throw_item($item[ice house]);
		break;


		case $monster[rack of free weights]:
		if (!(item_amount($item[porquoise-handled sixgun])==0)){
			throw_item($item[porquoise-handled sixgun]);
		}
		if(have_equipped($item[everfull dart holster])||have_equipped($item[jurassic parka])){
			while(current_round()>0 && have_skill($skill[Darts: Aim for the Bullseye])) use_skill($skill[Darts: Aim for the Bullseye]);
			if(current_round()>0 && have_skill($skill[Spit jurassic acid])) use_skill($skill[Spit jurassic acid]);
			break;
		}
		if (have_skill($skill[saucegeyser])){
			use_skill($skill[saucegeyser]);
		}
		break;


		case $monster[treadmill]:
		if (!(item_amount($item[porquoise-handled sixgun])==0)){
			throw_item($item[porquoise-handled sixgun]);
		}
		if(have_equipped($item[everfull dart holster])||have_equipped($item[jurassic parka])){
			while(current_round()>0 && have_skill($skill[Darts: Aim for the Bullseye])) use_skill($skill[Darts: Aim for the Bullseye]);
			if(current_round()>0 && have_skill($skill[Spit jurassic acid])) use_skill($skill[Spit jurassic acid]);
			break;
		}
		if (have_skill($skill[saucegeyser])){
			use_skill($skill[saucegeyser]);
		}
		break;


		case $monster[befouled straw house]:
		case $monster[dutch angle straw house]:
		case $monster[frosty straw house]:
		case $monster[oily straw house]:
		case $monster[steaming straw house]:
		
		if (scoreMatcher.find()){
			wolfScore = scoreMatcher.group(1).to_int();
		}
		print(wolfScore);
		
		if(wolfScore<to_int(get_property("unleashThreshold"))){
			if(contains_text(page,"Breath: 1/")||contains_text(page,"Breath: 0/")){
				if(contains_text(page,`title="Huff"`)){
					if(current_round() > 0) use_skill($skill[Huff]);
				}
			}
			if(contains_text(page,`title="Huff"`)){
				catch{
					if(current_round() > 0) use_skill($skill[Puff]);
				}
			}
		}
		else{
			if (get_property("wolfScore").to_int()==0) set_property("wolfScore",wolfScore.to_string());
			print(wolfScore+" should be enough to hit our goal of "+get_property("unleashThreshold"),"blue");
			matcher breathMatcher = create_matcher("Breath: (\\d+)/",page);
			if (breathMatcher.find()){
				currentBreath = breathMatcher.group(1).to_int();
			}
			if(!contains_text(page,"Breath: "+currentBreath+"/"+currentBreath)){
				if(contains_text(page,`title="Huff"`)){
					if(current_round() > 0) use_skill($skill[Huff]);
				}
			}
			if(contains_text(page,`title="Huff"`)){
				catch{
					if(current_round() > 0) use_skill($skill[Puff]);
				}
			}
		}
		break;
		
		case $monster[cold ironwood house]:
		case $monster[glowing ash house]:
		case $monster[pitch pine house]:
		case $monster[quaking aspen house]:
		case $monster[slippery elm house]:

		if (scoreMatcher.find()){
			wolfScore = scoreMatcher.group(1).to_int();
		}
		print(wolfScore);
		if (offenseMatcher.find()){
			wolfOffense = offenseMatcher.group(1).to_int();
		}
		if (defenseMatcher.find()){
			wolfDefense = defenseMatcher.group(1).to_int();
		}
		
		if(wolfScore<to_int(get_property("unleashThreshold"))){
			aspenHouseHP=max(1,150+75*to_int(get_property('housesEaten'))+monster_level_adjustment());
			aspenBlowsNeeded=ceil(aspenHouseHP/ceil(10*wolfOffense*(1-0.004*monster_level_adjustment())));
			stoneHouseHP=max(1,200+100*to_int(get_property('housesEaten'))+monster_level_adjustment());
			stoneBlowsNeeded=ceil(stoneHouseHP/ceil(10*wolfOffense*(1-0.004*monster_level_adjustment())));
			print("stone hp="+stoneHouseHP+", stone blows needed:"+stoneBlowsNeeded+", aspen hp="+aspenHouseHP+", aspen blows needed:"+aspenBlowsNeeded,"blue");
			if (stoneBlowsNeeded>aspenBlowsNeeded){
				print("probably worth fighting this one","blue");
				set_property("housesEaten",to_int(get_property("housesEaten"))+1);

				while(aspenBlowsNeeded>blowsDone){
					if(my_hp()<(aspenBlowsNeeded-blowsDone-1)*ceil(max(0.03,0.15-0.03*(wolfDefense-10-to_int(get_property("housesEaten"))+1))*my_maxhp())){
						print("skipping this one because it's going to deal "+(aspenBlowsNeeded-blowsDone-1)*ceil(max(0.03,0.15-0.03*(wolfDefense-10-to_int(get_property("housesEaten"))+1))*my_maxhp())+" damage","blue");
						set_property("housesEaten",to_int(get_property("housesEaten"))-1);
						if(current_round() > 0) use_skill($skill[Huff]);
						if(contains_text(page,`title="Huff"`)){
							if(current_round() > 0) use_skill($skill[Puff]);
						}
						break;
					}
					else{
						catch{
							if(contains_text(page,`title="Huff"`)&&(contains_text(page,"Breath: 1/")||contains_text(page,"Breath: 0/"))){
								if(current_round() > 0) use_skill($skill[Huff]);
							}
						}
						if(contains_text(page,'title="Huff"')){
							catch{
								blowsDone = blowsDone + 1;
								if(current_round() > 0) use_skill($skill[Blow House Down]);
							}
						}
					}
				}

			}
			else{
				print("skipping this one", "blue");

				if(contains_text(page,"Breath: 1/")||contains_text(page,"Breath: 0/")){
					if(contains_text(page,`title="Huff"`)){
						if(current_round() > 0) use_skill($skill[Huff]);
					}
				}
				if(contains_text(page,`title="Huff"`)){
					catch{
						if(current_round() > 0) use_skill($skill[Puff]);
					}
				}
			}
		}
		else{
			if (get_property("wolfScore").to_int()==0) set_property("wolfScore",wolfScore.to_string());
			print(wolfScore+" should be enough to hit our goal of "+get_property("unleashThreshold"),"blue");
			matcher breathMatcher = create_matcher("Breath: (\\d+)/",page);
			if (breathMatcher.find()){
				currentBreath = breathMatcher.group(1).to_int();
			}
			if(!contains_text(page,"Breath: "+currentBreath+"/"+currentBreath)){
				if(contains_text(page,`title="Huff"`)){
					if(current_round() > 0) use_skill($skill[Huff]);
				}
			}
			if(contains_text(page,`title="Huff"`)){
				catch{
					if(current_round() > 0) use_skill($skill[Puff]);
				}
			}
		}
		break;
		
		
		case $monster[brick icehouse]:
		case $monster[brick kiln]:
		case $monster[brick mausoleum]:
		case $monster[brick outhouse]:
		case $monster[brick (suggestive pause) house]:



		if (scoreMatcher.find()){
			wolfScore = scoreMatcher.group(1).to_int();
		}
		print(wolfScore);
		if (offenseMatcher.find()){
			wolfOffense = offenseMatcher.group(1).to_int();
		}
		if (defenseMatcher.find()){
			wolfDefense = defenseMatcher.group(1).to_int();
		}
		
		if(wolfScore<to_int(get_property("unleashThreshold"))){
			stoneHouseHP=max(1,200+100*to_int(get_property('housesEaten'))+monster_level_adjustment());
			stoneBlowsNeeded=ceil(stoneHouseHP/ceil(10*wolfOffense*(1-0.004*monster_level_adjustment())));
			print("stone hp="+stoneHouseHP+", stone blows needed:"+stoneBlowsNeeded,"blue");

			set_property("housesEaten",to_int(get_property("housesEaten"))+1);

			while(stoneBlowsNeeded>blowsDone){
				if(my_hp()<(stoneBlowsNeeded-blowsDone-1)*ceil(max(0.03,0.15-0.03*(wolfDefense-10-to_int(get_property("housesEaten"))+1))*my_maxhp())){
					set_property("housesEaten",to_int(get_property("housesEaten"))-1);
					if(current_round() > 0) use_skill($skill[Huff]);
					if(contains_text(page,`title="Huff"`)){
						if(current_round() > 0) use_skill($skill[Puff]);
					}
					break;
				}
				else{
					catch{
						if(contains_text(page,`title="Huff"`)&&(contains_text(page,"Breath: 1/")||contains_text(page,"Breath: 0/"))){
							if(current_round() > 0) use_skill($skill[Huff]);
						}
					}
					if(contains_text(page,'title="Huff"')){
						catch{
							blowsDone = blowsDone + 1;
							if(current_round() > 0) use_skill($skill[Blow House Down]);
						}
					}
				}
			}
		}
		else{
			if (get_property("wolfScore").to_int()==0) set_property("wolfScore",wolfScore.to_string());
			print(wolfScore+" should be enough to hit our goal of "+get_property("unleashThreshold"),"blue");
			matcher breathMatcher = create_matcher("Breath: (\\d+)/",page);
			if (breathMatcher.find()){
				currentBreath = breathMatcher.group(1).to_int();
			}
			if(!contains_text(page,"Breath: "+currentBreath+"/"+currentBreath)){
				if(contains_text(page,`title="Huff"`)){
					if(current_round() > 0) use_skill($skill[Huff]);
				}
			}
			if(contains_text(page,`title="Huff"`)){
				catch{
					if(current_round() > 0) use_skill($skill[Puff]);
				}
			}
		}
		break;

	}
	
	
	
	if(contains_text(page,'Outer Wolf') && !contains_text(page,'2 vials of lupine appetite hormones')) {
		if (to_int(get_property("unleashThreshold"))<wolfScore){
			print("Guess we gotta try harder than that.", "blue");
			set_property("unleashThreshold", to_string(wolfScore + 4));
		}
		abort();
	}
}
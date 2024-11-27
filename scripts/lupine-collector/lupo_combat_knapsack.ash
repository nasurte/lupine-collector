int [int] houseNeededHits;
int wolfOffense;
float [int, int, int, int] table;
float houseHp(int houseType, int unleashCount) {
    return max(1,(houseType+1)*25*(2+unleashCount)+monster_level_adjustment());
}

void dp(int maxBreath, int currentBreath, int unleashCount, int effectiveDamage, int effectiveHp) {
    #table [a, x, y, z] = expected max score on house a during x unleashes, with y hp and z breath
    
    for unleashRound from 39 downto unleashCount {
        for hp from 1 to effectiveHp {
            for breath from 0 to maxBreath{
                for house from 1 to 3{
                    #blow
                    float blow = 0;
                    int blowHp = hp;
                    int blowBreath = breath;
                    int hitsNeeded = ceil(houseHP(house, unleashRound)/effectiveDamage);
                    int blowsDone = 0;
                    while(blowsDone < hitsNeeded) {
                        blowsDone = blowsDone + 1;
                        blowHp = blowHp - 1;
                        blowBreath = blowBreath - 1;
                        while(blowBreath <= 1) {
                            blowBreath = blowBreath + floor(maxBreath/3);
                            blowHp = blowHp - 1;
                        }
                    }
                    if(blowHp > 0) {
                        blow = house + table[0, unleashRound + 1, blowHp, blowBreath];
                    }
                    #puff
                    float puff = 0;
                    int puffHp = hp;
                    int puffBreath = breath - 1;
                    while(puffBreath <= 1) {
                        puffhp = puffHp - 1;
                        puffBreath = puffBreath + floor(maxBreath / 3);
                    }
                    if(puffHp > 0) {
                        puff = table[0, unleashRound, puffHp, puffBreath];
                    }
                    table[house, unleashRound, hp, breath] = max(blow, puff);
                    table[0, unleashRound, hp, breath] += table[house, unleashRound, hp, breath];
                }
                table[0, unleashRound, hp, breath] = table[0, unleashRound, hp, breath] / 3;
            }
        }
    } 
}

int take_house(int houseType, int unleashCount, int effectiveDamage, string page) {
    int effectiveHp = ceil(my_hp()/floor(0.03*my_maxhp()));
    int currentBreath, maxBreath;
	matcher breathMatcher = create_matcher("Breath: (\\d+)/",page);
	
	if (breathMatcher.find()){
		currentBreath = breathMatcher.group(1).to_int();
	}

	matcher maxBreathMatcher = create_matcher("Breath: "+currentBreath.to_string()+"/(\\d+)",page);
	if (maxBreathMatcher.find()){
		maxBreath = maxBreathMatcher.group(1).to_int();
	}
    print(maxBreath);
    print(currentBreath);

    for unleashRound from unleashCount to 40 {
        for hp from effectiveHp downto 1 {
            for breath from maxBreath downto 0 {
                for i from 1 to 3{
                    table [i, unleashRound, hp, breath] = 0;
                }
            }
        }
    } 
    dp(maxBreath, currentBreath, unleashCount, effectiveDamage, effectiveHp);
    
    float blow = 0;
    float puff = 0;
    int puffHp = effectiveHp;
    int puffBreath = currentBreath - 1;
    while(puffBreath <= 1) {
        puffBreath = puffBreath + floor(maxBreath/3);
        puffHp = puffHp - 1;
    }
    int blowsDone = 0;
    int blowHp = effectiveHp;
    int blowBreath = currentBreath;
    while(blowsDone < houseNeededHits[houseType]) {
        blowsDone = blowsDone + 1;
        blowHp = blowHp - 1;
        blowBreath = blowBreath - 1;
        while(blowBreath <= 1) {
            blowBreath = blowBreath + floor(maxBreath/3);
            blowHp = blowHp - 1;
        }
    }
    if(puffHp > 0)
        puff = table[0, unleashCount, puffHp, puffBreath];
    if(blowHp > 0)
        blow = houseType + table[0, unleashCount + 1, blowHp, blowBreath];
    print(puff);
    print(blow);
    if(puff > blow)
        return 1;
    return 0;
}


void main(int initround, monster foe, string page){
	matcher offenseMatcher = create_matcher("Offense: (\\d+)",page);
	if (offenseMatcher.find()){
		wolfOffense = offenseMatcher.group(1).to_int();
	}
    int effectiveDamage = 10*wolfOffense*(1-0.004*monster_level_adjustment());
    int currentUnleash = get_property("housesEaten").to_int();
    
    if(effectiveDamage > 0) {
        for i from 1 to 3{
            houseNeededHits[i] = ceil(houseHP(i, currentUnleash)/effectiveDamage);
        }
    }

    int pigCount = -1;
    switch(foe){
        case $monster[Abcrusher 4000&trade;]:
			if(have_skill($skill[Transcendent Olfaction])&&(get_property("olfactedMonster")=="Abcrusher 4000™"||get_property("_olfactionsUsed").to_int()<3)){
				if(((!(get_property("olfactedMonster")=="Abcrusher 4000™"))||(have_effect($effect[On the Trail])==0))&&(get_property("_olfactionsUsed").to_int() < 3)){
					use_skill($skill[Transcendent Olfaction]);
				}
			}
			else{
				if(have_skill($skill[Gallapagosian Mating Call])&&!(get_property("_gallapagosMonster")=="Abcrusher 4000&trade;")){
					use_skill($skill[Gallapagosian Mating Call]);
				}
			}
            
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
			if(have_skill($skill[Transcendent Olfaction])&&(get_property("olfactedMonster")=="Abcrusher 4000™"||get_property("_olfactionsUsed").to_int()<3)){
				if(have_skill($skill[Gallapagosian Mating Call])&&!(get_property("_gallapagosMonster")=="rack of free weights")){
					use_skill($skill[Gallapagosian Mating Call]);
				}
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

        case $monster[treadmill]:
			if(have_skill($skill[Transcendent Olfaction])&&(get_property("olfactedMonster")=="Abcrusher 4000™"||get_property("_olfactionsUsed").to_int()<3)){
				if((my_familiar() == $familiar[Nosy Nose])&&!(get_property("nosyNoseMonster")=="treadmill")){
					use_skill($skill[Get a Good Whiff of This Guy]);
				}
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

        case $monster[befouled straw house]:
        case $monster[dutch angle straw house]:
        case $monster[frosty straw house]:
        case $monster[oily straw house]:
        case $monster[steaming straw house]:

            pigCount = 1;
            break; 

        case $monster[cold ironwood house]:
        case $monster[glowing ash house]:
        case $monster[pitch pine house]:
        case $monster[quaking aspen house]:
        case $monster[slippery elm house]:

            pigCount = 2;
            break;

        case $monster[brick icehouse]:
        case $monster[brick kiln]:
        case $monster[brick mausoleum]:
        case $monster[brick outhouse]:
        case $monster[brick (suggestive pause) house]:

            pigCount = 3;
            break;

    }

    if(pigCount > 0) {
	
		int wolfScore;
		matcher scoreMatcher = create_matcher("Score:(\\d+)",page);
		if (scoreMatcher.find()){
			wolfScore = scoreMatcher.group(1).to_int();
		}
        print(wolfScore,"blue");
		
        if(wolfScore >= get_property("unleashThreshold").to_int() || take_house(pigCount, currentUnleash, effectiveDamage, page) == 1) {
			if(wolfScore >= get_property("unleashThreshold").to_int()){
				if (get_property("wolfScore").to_int()==0) set_property("wolfScore",wolfScore.to_string());
				print(wolfScore+" should be enough to hit our goal of "+get_property("unleashThreshold"),"blue");
				if(contains_text(page,`title="Huff"`)){
					catch{
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
				if(contains_text(page,"Breath: 2/")||contains_text(page,"Breath: 1/")||contains_text(page,"Breath: 0/")){
					if(contains_text(page,`title="Huff"`)){
						use_skill($skill[Huff]);
					}
				}
				if(contains_text(page,`title="Huff"`)){
					catch{
						if(current_round() > 0)
							use_skill($skill[Puff]);
					}
				}
			}
        }
        
        else{
            set_property("housesEaten", currentUnleash + 1);
            int blowsDone;
            print(currentUnleash);
            print(monster_hp());
            print(monster_level_adjustment());


            while (blowsDone < houseNeededHits[PigCount] + 1 && current_round() > 0){
                catch{
                    if(contains_text(page,`title="Huff"`)){
                        if(contains_text(page,"Breath: 2/")||contains_text(page,"Breath: 1/")||contains_text(page,"Breath: 0/")){
                            use_skill($skill[Huff]);
                        }
                    }
                }
                if(contains_text(page,'title="Huff"')){
                    catch{
                        blowsDone = blowsDone + 1;
                        use_skill($skill[Blow House Down]);
                    }
                }
            }
        }
    }


}

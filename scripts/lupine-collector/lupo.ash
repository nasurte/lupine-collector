
void main(string... args){

if(count(args)>0 && args[0].to_lower_case().contains_text("help")){
	print_html("<b>You can pass these as args or set 'em as prefs before running the script:</b>");
	print_html("<font color=800080>NUMBER</font> - try to run this many masks. If unspecified, does only 1 run.");
	print_html("<font color=0000FF>help</font> - display this message.");
	print_html("<font color=0000FF>continue</font> - if in the middle of a run, try to finish it instead of using a new mask. <font color=A9A9A9>[default: false] [setting: lupoContinue]</font>");
	print_html("<font color=0000FF>wish</font> - use cursed monkey's paw/genie/pocket wishes for turns of Offhand Remarkable if it makes sense to do so. <font color=A9A9A9>[default: false] [setting: lupoUseWishes]</font>");
	print_html("<font color=0000FF>knapsack</font> - use a different consult script in house combats, courtesy of Pyacide. Should result in higher scores, but also causes runs to take about twice as long. <font color=A9A9A9>[default: false] [setting: lupoKnapsack]</font>");
	print_html("<font color=0000FF>This last one doesn't have an arg.</font> - The score thresholds for receiving lupine appetite hormones at the end are determined by previous runs, so to keep this sustainable for as long as possible we want to do only the bare minimum. At what point should we stop trying to win house fights? (adjusts automatically every time we fail to get 2 vials) <font color=A9A9A9>[default: 110] [setting: unleashThreshold]</font>");
}else{
	boolean lupoContinue=(count(args)>0 && args[0].to_lower_case().contains_text("continue")||get_property("lupoContinue")=="true"?true:false);
	boolean lupoUseWishes=(count(args)>0 && args[0].to_lower_case().contains_text("wish")||get_property("lupoUseWishes")=="true"?true:false);
	boolean lupoKnapsack=(count(args)>0 && args[0].to_lower_case().contains_text("knapsack")||get_property("lupoKnapsack")=="true"?true:false);

	int masks=1;
	if (count(args)>0){
		matcher masksMatcher = create_matcher("(\\d+)",args[0]);
		if(masksMatcher.find()){
			masks=masksMatcher.group(1).to_int();
		}
	}

	//set ccs and such
	write_ccs((lupoKnapsack?to_buffer("consult lupo_combat_knapsack"):to_buffer("consult lupo_combat.ash")),"lupo");
	cli_execute('ccs lupo'); 
	if(get_property("unleashThreshold")=="") set_property("unleashThreshold","110");
	if(get_property("lupoLastUsed").to_int()!=daycount()){
		set_property("lupoLastUsed",daycount().to_string());
		set_property("lupoMasksToday","0");
		set_property("lupoLupinesToday","0");
	}
	set_property("hpAutoRecoveryTarget","0.5");
	set_property("hpAutoRecovery","0.05");
	set_property("mpAutoRecoveryTarget","1.0");
	set_property("mpAutoRecovery","0.3");

	if(have_effect($effect[angering pizza purists]).to_boolean()) cli_execute("shrug angering pizza purists");
	

	int startingLupines=item_amount($item[lupine appetite hormones]);
	int startingCologne=item_amount($item[Outer Wolf&trade; cologne]);
	try{
		for run from 1 to masks{
			
			print('Starting run #'+run+'!','blue');
			int lupines=item_amount($item[lupine appetite hormones]);
			
			if(lupoContinue&&run==1){
				run_turn();
				while(in_multi_fight()) run_combat();
			}
			if (!visit_url('place.php?whichplace=ioty2014_wolf').contains_text("Time Left: 30")&&!lupoContinue||visit_url('place.php?whichplace=ioty2014_wolf').contains_text("All good things")){
				if(item_amount($item[grimstone mask])==0){
					buy($item[grimstone mask],1,30000);
				}
				set_property('choiceAdventure829',2);
				use($item[grimstone mask]);
			}
			cli_execute('outfit birthday suit');
	
						 //~~setting a bunch of stuff that mafia doesn't have prefs for~~
						 //mafia now has prefs for these but iirc some of them are slightly off in some way

			string page;
			page=visit_url('place.php?whichplace=ioty2014_wolf');
			matcher offenseMatcher = create_matcher("Offense: (\\d+)",page);
			matcher defenseMatcher = create_matcher("Defense: (\\d+)",page);
			matcher breathMatcher = create_matcher("Breath: (\\d+)/(\\d+)",page);
			matcher timerMatcher = create_matcher("Time Left: (\\d+)",page);
			 
			int timer;
			if(timerMatcher.find()){
				timer=timerMatcher.group(1).to_int();
			}
			print(timer);
			
			int wolfDefense;
			if(defenseMatcher.find()){
				wolfDefense=defenseMatcher.group(1).to_int();
			}
			print(wolfDefense);
			 
			int wolfOffense;
			if(offenseMatcher.find()){
				wolfOffense=offenseMatcher.group(1).to_int();
			}
			print(wolfOffense);
			 
			int wolfMaxBreath;
			if(breathMatcher.find()){
				wolfMaxBreath=breathMatcher.group(2).to_int();
			}
			print(wolfMaxBreath);
			 
			boolean howlImproved;
			if (timer<25){
				howlImproved=true;
			}
			else {
				howlImproved=false;
			}

						 //Gym advs

			if(my_hp()<my_maxhp()){
				use_skill($skill[cannelloni cocoon]);
			}
			
			if(have_familiar($familiar[reagnimated gnome])){
				use_familiar($familiar[reagnimated gnome]);
			}
			else if(have_familiar($familiar[Nosy Nose])&&(have_skill($skill[Transcendent Olfaction])&&(get_property("olfactedMonster")=="Abcrusher 4000™"||get_property("_olfactionsUsed").to_int()<3))){
				use_familiar($familiar[Nosy Nose]);
			}

			string maximizerStuff;
			maximizerStuff+=" item drop, -equip broken champagne bottle, 400 bonus thumb ring, 90 bonus mr. cheeng's spectacles, 400 bonus carnivorous potted plant";
			if(my_familiar()==$familiar[reagnimated gnome]) maximizerStuff+=", +equip gnomish housemaid's kgnee, 10 familiar weight";
			cli_execute("maximize"+maximizerStuff);
			item bufferShirt=equipped_item($slot[shirt]);
			item bufferAcc;
			slot accBuffer;
			if(have_equipped($item[mafia thumb ring])){
				accBuffer=$slot[acc1];
				bufferAcc=$item[mafia thumb ring];
			}
			else{
				accBuffer=$slot[acc3];
				bufferAcc=equipped_item($slot[acc3]);
			}

			if (timer>12){
				for i from timer to 13{

				//Cooldown:
				//830-1;832-1:+5 Offense
				//830-1;832-2:+5 Defense
				//830-3;834-2:Improved Howling
				//830-3;834-3:+3 Lung Capacity
				
				if(timer==25||timer==19||timer==13){
					if (timer<24){
						howlImproved = true;
					}
					if (!howlImproved){
						set_property("choiceAdventure830",3);
						set_property("choiceAdventure834",2);
					}
					else if (have_skill($skill[Transcendent Olfaction])&&(get_property("olfactedMonster")=="Abcrusher 4000™"||get_property("_olfactionsUsed").to_int()<3)){
						if((wolfMaxBreath<6 && timer>17)||(wolfOffense>23 && wolfMaxBreath<9)){
							set_property("choiceAdventure830",3);
							set_property("choiceAdventure834",3);
						}
						else{
							set_property("choiceAdventure830",1);
							set_property("choiceAdventure832",1);
						}
					}
					else{
						if((wolfMaxBreath<9 && timer<17)|| wolfMaxBreath<6){
							set_property("choiceAdventure830",3);
							set_property("choiceAdventure834",3);
						}
						else if((wolfDefense<19 && timer<17)|| wolfDefense<28){
							set_property("choiceAdventure830",1);
							set_property("choiceAdventure832",2);
						}
						else{
							set_property("choiceAdventure830",1);
							set_property("choiceAdventure832",1);
						}
					}
				}
				
				//equip juggling
				
				if (item_amount($item[everfull dart holster])>0 && !have_effect($effect[everything looks red]).to_boolean()&& !have_equipped($item[everfull dart holster])) equip(accBuffer,$item[everfull dart holster]);
				if (have_effect($effect[everything looks red]).to_boolean()&& have_equipped($item[everfull dart holster])) equip(accBuffer,bufferAcc);
				if (item_amount($item[jurassic parka])>0 && !have_effect($effect[everything looks yellow]).to_boolean()&&!have_equipped($item[jurassic parka])){
					equip($item[jurassic parka]);
					cli_execute("parka acid");
				}
				if (have_effect($effect[everything looks yellow]).to_boolean() && have_equipped($item[jurassic parka])) equip(bufferShirt);
				
				timer = timer - 1;
				adv1($location[The Inner Wolf Gym],-1,"");

				//updating stats

				page=visit_url('place.php?whichplace=ioty2014_wolf');
				matcher offenseMatcher = create_matcher("Offense: (\\d+)",page);
				matcher defenseMatcher = create_matcher("Defense: (\\d+)",page);
				matcher breathMatcher = create_matcher("Breath: (\\d+)/(\\d+)",page);
				
				if(defenseMatcher.find()){
					wolfDefense=defenseMatcher.group(1).to_int();
				}
				print(wolfDefense);
				 
				if(offenseMatcher.find()){
					wolfOffense=offenseMatcher.group(1).to_int();
				}
				print(wolfOffense);
				 
				if(breathMatcher.find()){
					wolfMaxBreath=breathMatcher.group(2).to_int();
				}
				print(wolfMaxBreath);

				}
			}


					   //skid row advs

			if (!have_familiar($familiar[left-hand man])){
				use_familiar($familiar[left-hand man]);
			}
			else if(have_familiar($familiar[teddy borg])){
				use_familiar($familiar[teddy borg]);
			}
			cli_execute("maximize -ML, 200 bonus june cleaver, 100 bonus designer sweatpants");

			while(my_hp()<my_maxhp()){
				use_skill($skill[cannelloni cocoon]);
			}
			if(!lupoContinue||run>1) set_property("wolfScore","0");
			
			if(timer>2) for i from 1 to timer/3{
			
				if (lupoUseWishes && have_equipped($item[HOA regulation book]) && have_effect($effect[Offhand Remarkable])<4){
					if(item_amount($item[cursed monkey's paw])>0&&get_property("_monkeyPawWishesUsed").to_int()<5){
						cli_execute("monkeypaw effect offhand remarkable");
					}else{
						retrieve_item($item[pocket wish],1);
						cli_execute("genie effect offhand remarkable");
					}
				}

				visit_url('place.php?whichplace=ioty2014_wolf&action=wolf_houserun'); 
				set_property("housesEaten","0");
				use_skill($skill[Puff]);
				while(in_multi_fight()){
					run_combat();
				}
				
				while(get_property("_sweatOutSomeBoozeUsed").to_int()<3&&get_property("sweat").to_int()>24&&my_inebriety()>0){
					cli_execute('/cast sweat out some booze');
				}
				if(get_property("sweat").to_int()>49){
					cli_execute('/cast make sweat-ade');
				}
				if(get_property("sweat").to_int()>49){
					cli_execute('/cast make sweat-ade');
				}
				
				while(my_hp()<my_maxhp() && get_property("wolfScore").to_int()<get_property("unleashThreshold").to_int()){
					use_skill($skill[cannelloni cocoon]);
				}
				

				if(get_property("_juneCleaverFightsLeft")=='0'){
					adv1($location[Noob Cave],-1,"");
				}

			}
			
			if(item_amount($item[lupine appetite hormones])-lupines<2&&get_property("wolfScore").to_int()>=get_property("unleashThreshold").to_int()){
				if(item_amount($item[lupine appetite hormones])-lupines==1){
					print("gotta try harder than that", "blue");
					set_property("unleashThreshold",to_string(get_property("unleashThreshold").to_int()+5));
				}
				else{
					abort("what the hell");
				}
			}
		}
	}
	finally{
		//results and stuff
		//lie to mafia so that garbo doesn't complain later
		set_property("_lastCombatLost","false"); 
		print('should be done','blue');
		string plural;
		int masksUsed=item_amount($item[Outer Wolf&trade; cologne])-startingCologne;
		if(masksUsed!=1) plural="s";
		set_property("lupoMasksToday",to_string(masksUsed+get_property("lupoMasksToday").to_int()));
		set_property("lupoLupinesToday",to_string(item_amount($item[lupine appetite hormones])-startingLupines+get_property("lupoLupinesToday").to_int()));
		print("we've run "+masksUsed+" mask"+plural+" and collected "+(item_amount($item[lupine appetite hormones])-startingLupines)+" vials of lupine appetite hormones","blue");
		if(masksUsed<masks){
			print("looks like something went wrong", "red");
		} else if(item_amount($item[lupine appetite hormones])-startingLupines==2*masks){
			print("good job!", "blue");
		}
		else{
			print("good job, probably!", "blue");
		}
		print("in total, we've finished "+get_property("lupoMasksToday")+" runs and generated "+get_property("lupoLupinesToday")+" vials of lupine appetite hormones today","blue");
	}

}
}
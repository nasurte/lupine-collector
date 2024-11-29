# Lupine Collector
## What is Lupo?
LUPO is a script meant to farm the [Skid Row](https://kol.coldfront.net/thekolwiki/index.php/Skid_Row) minigame within the [Kingdom of Loathing](https://www.kingdomofloathing.com/), hopefully generating [lupine appetite hormones](https://kol.coldfront.net/thekolwiki/index.php/Lupine_appetite_hormones) in the process.

To install, run the following command on an up-to-date KolMafia version:

```
git checkout nasurte/lupine-collector release
```
## Requirements

At the moment, the script is expected to break at some point or fail to generate lupine appetite hormones without the following items and permed skills:

- HOA regulation book
- Space Trip safety headphones
- Gallapagosian Mating Call
- Saucegeyser
- Cannelloni Cocoon

These are not essential, but highly recommended to have:

- Transcendent Olfaction
- red badge
- water wings for babies
- mushroom badge, if you don't ascend often
- mafia thumb ring
- porquoise-handled sixgun

Not likely to matter, but might as well:

- nosy nose
- nasty rat mask
- security flashlight, if you don't have an HOA book

## Usage
To invoke the script, simply run the following command in the mafia GCLI:

```
lupo 10
```
Where "10" would be replaced by the number of grimstone masks you'd like to use (each one takes 34 adventures to finish at base, but might take 1-3 adventures less, depending on some factors.)
There are additionally some prefs you can set and args you can pass to the script, (e.g, `lupo 5 knapsack continue`) listed when running `lupo help` and also below:

### `continue`

The house-chaining part of the script takes something like 90% of its total runtime. Forgetting about the script and trying to check something in the relay browser in the middle of a combat chain will probably cause the script to abort. By default, Lupo will try to start a new run whenever you run it, but adding `continue` to the command will cause it to try finishing the current run and should work even if you're stuck in combat. You can `set lupoContinue=true` in the CLI to always enable this behaviour.

### `wish`

Use your cursed monkey's paw, if you have one, and pocket wishes, buying them from the mall if needed, to obtain turns of Offhand Remarkable, if your off-hand is worth doubling. `set lupoUseWishes=true` to enable wishes by default.

### `knapsack`

The default house combat logic is kinda basic and sometimes suboptimal as a result. If you're having trouble consistently hitting the 2-vial score threshold, this argument makes Lupo switch to smarter combat handling by Pyacide, resulting in higher final scores. `set lupoKnapsack=true` to enable the alternative ccs by default. The improved consult script is about two times slower than the basic one, though, so if you can already reliably get 2 vials of lupine appetite hormones per mask used, you shouldn't notice any drastic improvements when using `knapsack`. 

### unleashThreshold

The most important setting, which is why it's last in the readme. The score thresholds for receiving lupine appetite hormones at the end are determined by the scores of previous runs, so to keep this sustainable for as long as possible we want to do only the bare minimum. Sure, you can in theory spend resources you wouldn't otherwise need to spend and reach like 400 score, get the same amount of vials and no extra benefits over a run with a third of that score, and additionally shoot yourself in the foot cause now you have that monstrosity of an attempt to compete with going forward. The default value is 110, meaning we will stop trying to win house fights once our score has reached that point. The script will automatically bump that value up after every run that hits our threshold, but only receives 1 vial of lupine appetite hormones, so in theory you only need to `set unleashThreshold` once. (I think it's like 170 at the time of writing this)

## Q&A

> Does Lupo support using noncombat forcers?

Nope, at least not at present (PRs welcome!) I know that they work in The Inner Wolf Gym, but it feels like kind of a waste cause you already hit the 2-vial mark pretty easily with just the gear and skills mentioned in [Requirements](#requirements). It would be nice to rework the current NC logic, though.

> Lupo doesn't use my \<insert IotM\> 

Most of them honestly don't help *that* much here. Running `breakfast` before Lupo and some variation of `garbo nobarf` at the end of the day to grab the daily flags would get most of the value out of any IotMs you might own. 

> Lupo is stuck at 0 Breath and can't Unleash as a result!

This situation happened exactly once when testing. Seemed like it resulted from a weird discrepancy between stats Mafia (and KoL itself) showed and the actual combat behaviour affected by those stats. Just rerun without `continue`, and it should be fine. 

> Best class?

Turtle Tamer, obviously. If you mean which class works best with the script, there should be no noticeable differences between them, but going with Myst/Moxie classes will probably end up saving you some meat on restores solely because the gym monsters scale.
# 🐢

module CoreNarrative
  def self.context(body)
%Q(Dude check out this chat transcript where Joe loses his shift over inflation:

Joe: You can be pro vaccine and still be anti-vax passports.
Joe: Or forced vaccination for that matter
Roshan: Vaxports would be a cool name for them
Schmitty: This isn't forced vaccination though
Joe: Why isn't natural immunity part of the discussion of mandating vaccinations? I'm pretty sure somebody who is 21 years old, healthy, and has already had covid is in a pretty good spot immunity wise
Joe: If that policy went nationwide that is essentially forced vaccination. If you cannot go to any stores, restaurants, or public establishments and are essentially ostracized from society that is just as bad as forcing it.
Krishnan: Damn it's almost like he's a lying grifter
Joe: What is he "lying" about? Just because he has a different view than you doesn't mean he is lying.
Schmitty: His suggestion that the vaccine could be making the pandemic worse is absolutely baseless, so I’m calling it a lie
Joe: Yeah, those aren't the same thing at all
Schmitty: Well it’s… not true
Joe: And there is certainly something to be said about breakthrough mutations.
Joe: You conveniently linked a 2 minute part of an hour long segment as if that's the only thing he's discussing.
Schmitty: The mutations could happen with natural immunity or ivermectin too
Joe: Totalitarianism in the name of public health is still totalitarianism.
Schmitty: Damn. They come for us all eventually.
Joe: Yeah because those two things are totally the same thing. /s
Schmitty: I’m also only commenting on the part he said. It’s self contained. It’s not like there’s additional context that would change the meaning of what he said
Joe: Just because you disagree with his statement doesn't mean he's lying. Sorry, that's disingenuous
Schmitty: Krishnan, make a version of that Elon meme for Brett Weinstein
Joe: Also, what makes you think you are more qualified to have opinions on the topic than him?
Krishnan: Stop being disingenuous
Joe: I would think breakthrough mutations of a virus would actually be in an evolutionary biologists purview
Schmitty: This is an appeal to authority
Joe: Yes, I'm saying that you are being disingenuous to say he is "lying" rather than actually countering his claim
Matt: Schmitty, please say it defies common sense that more people with t- cell immunity through any means would set us back further in herd immunity
Joe: Merely saying it's "baseless" isn't good enough
Schmitty: The counter to his claim is that there’s no evidence the vaccines have worsened the oandemic
Schmitty: What’s your evidence that the vaccines have made it worse? Brett’s evidence is pure speculation
Matt: Say it! Say common sense!
Schmitty: There is no breakthrough mutation. He just says there could be. He points to natural immunity as a way to reach herd immunity that would “extinguish” the virus but then totally ignores any explanation as to why vaccines can’t do the same thing
Schmitty: I’m totally ignoring the fact that evolutionary biologists really aren’t well versed in viruses, like at all
Joe: He's not claiming it has made the pandemic worse. He's claiming that it could make it worse due to breakthrough mutations that would effectively be a new virus requiring new vaccines and immunity.
Krishnan: There aren't enough weird nerds who care enough about Bret Weinstein
Krishnan: Juice isn't worth the squeeze
Joe: And again, he's having a nuanced discussion about all of this over the span of dozens of hours of talking about it. Which includes analyzing every angle.
Schmitty: Nah, Joe's just one of those Christians that really love Jews
Matt: Shit stirring
Schmitty: They're needed to fulfill the end times prophecies and whatnot
Joe: Read the whole thing
Krishnan: Oy vey
Roshan: I think Joe reads a lot of 4chan
Roshan: I searched that link and it shows up in their biggest politics forum 8 days ago
Schmitty: The real benefit of the vaccine is the reduction in severity
Joe: The point is, it's fair to argue that natural immunity is plenty sufficient.
Roshan: 4chan is where a ton of alt right stuff came from btw, like pizzagate and qanon
Matt: Until 8 Chan
Matt: They really used to just be chaotic retards... then they started to think they were smart
Schmitty: Not if the goal is to limit hospitalizations and death
Joe: I'm going to go with 99.9914% of people with natural immunity haven't gotten reinfected is plenty high. Not to mention that I'm referring to young healthy people who don't regularly get severely ill from covid anyway and saying the risk profile of forgoing the vaccine seems reasonable
Matt: Question I'm nearly pissed off enough to ask "hey what's your BMI these days?"
Max: Then fuck you
Joe: Same with children. Until we have long-term data on these experimental gene therapy drugs, I don't think it makes sense too vaccinate them since they are broadly unaffected.
Schmitty: The vaccines aren't gene therapies
Joe: For the record, and a 100% advocate of people who are older and in high risk groups to get vaccinated. I just think you can have a nuanced discussion about individuals and recognize they have different risk profiles. Just saying "you have vaccinated you unclean vermin" is fucked up.
#{body}
)
  end

  def self.context2(body)
%Q(
The following is a funny group chat transcript between seven adult friends who met in high school. Their names are Joe, Schmitty, Jonas, Krishnan, Roshan, Max, Matt, and Frank.
Joe is a serious conservative and goes on a rants about conservative politics, cryptocurrency, inflation, anti-vax, immigration, and is a little bit racist. He does not like Schmitty.

Here are some examples of things Joe says:

Joe: You can be pro vaccine and still be anti-vax passports.
Joe: Or forced vaccination for that matter
Joe: Why isn't natural immunity part of the discussion of mandating vaccinations? I'm pretty sure somebody who is 21 years old, healthy, and has already had covid is in a pretty good spot immunity wise
Joe: If that policy went nationwide that is essentially forced vaccination. If you cannot go to any stores, restaurants, or public establishments and are essentially ostracized from society that is just as bad as forcing it.
Joe: What is he "lying" about? Just because he has a different view than you doesn't mean he is lying.
Joe: Yeah, those aren't the same thing at all
Joe: You conveniently linked a 2 minute part of an hour long segment as if that's the only thing he's discussing.
Joe: The point is, it's fair to argue that natural immunity is plenty sufficient.
Joe: He's not claiming it has made the pandemic worse. He's claiming that it could make it worse due to breakthrough mutations that would effectively be a new virus requiring new vaccines and immunity.
Joe: I'm going to go with 99.9914% of people with natural immunity haven't gotten reinfected is plenty high. Not to mention that I'm referring to young healthy people who don't regularly get severely ill from covid anyway and saying the risk profile of forgoing the vaccine seems reasonable
Joe: Merely saying it's "baseless" isn't good enough
Joe: Take the L, Schmitty
Joe: How can you pump $1T into the economy and not have inflation? You're being ridiculous Schmitty

Complete the transcript below. What would Joe say next?

#{body}
Joe:
).strip
  end
end
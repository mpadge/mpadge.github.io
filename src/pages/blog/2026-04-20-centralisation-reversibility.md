---
title: Centralisation, reversibility, and restarting
description: 'Technical progress tends toward centralisation: telephone multiplexing
  made calls easier and centralised the entire telephone industry; GitHub made coding
  easier and centralised the world of software development. Technical centralisation
  is mostly reversible. The economic and political centralisation that rides alongside
  it is not. The real binding force is neither the technology nor the data but the
  interfaces imposed to make it all work together. One of the best ways to ensure
  centralising tendencies can be reversed is to find ways to keep those interfaces
  simple.'
date: 22/05/2026
tags: github
link: centralisation-reversibility.html
mastodon: https://nerdculture.de/@mpadge/116617670993736398
links:
  https://arxiv.org/abs/2503.13395: |
    '_Causal Emergence 2.0: Quantifying emergent complexity_', paper by Erik Hoel on arxiv.org (2025).
  https://en.wikipedia.org/wiki/Centre_national_d%27%C3%A9tudes_des_t%C3%A9l%C3%A9communications: |
    _Centre national d'études des télécommunications_, the French research centre established in 1944 (Wikipedia page).
  https://scholarship.law.columbia.edu/books/176/: |
    '_The Master Switch: The Rise and Fall of Information Empires_', a book by Tim Wu (2010).
  https://github.com/features/actions: |
    '_Automate your workflow from idea to production_' - web page for GitHub Actions.
  https://direct.mit.edu/books/monograph/1856/Design-Rules-Volume-1The-Power-of-Modularity: |
    '_Design Rules Volume 1: The Power of Modularity_', a book by Carliss Y. Baldwin and Kim B. Clark (2000).
  https://arxiv.org/abs/2507.09599: |
    '_Complexity and Coupling: A Functional Domain Approach_', paper by Aydin Homay on arxiv.org (2025).
  https://codeberg.org/mpadge/mpadge/src/branch/source/statichost.yml: |
    Interface between source for this site at codeberg.org/mpadge/mpadge and web hosting service at statichost.eu. The 3 lines are:
    `image: node:22`
    `command: npm install -g gulp-cli && yarn install && yarn build`
    `public: dist`
  https://ropensci.org/blog/2025/12/17/beyond-github/: |
    rOpenSci post on decentralised code hosting and alternatives to GitHub.
  https://codeberg.org/mpadge/mpadge: This site's source repository on Codeberg.
  http://statichost.eu: EU-based static site hosting service used to build and serve
    this site.

---

# Centralisation, reversibility, and restarting

<div class="summary-block">

Technical progress tends toward centralisation: telephone multiplexing
made calls easier and centralised the entire telephone industry; GitHub
made coding easier and centralised the world of software development.
Technical centralisation is mostly reversible. The economic and
political centralisation that rides alongside it is not. The real
binding force is neither the technology nor the data but the interfaces
imposed to make it all work together. One of the best ways to ensure
centralising tendencies can be reversed is to find ways to keep those
interfaces simple.

</div>

<div class="use-dropcap">

</div>

This is a restart of a blog. It used to be made in a fairly customised
way, as described in one of the [earlier
posts](/blog/making-this-site.html)[^1], but other than that it was
hosted, built, and deployed on GitHub. Your one-stop shop for all things
programmery. GitHub made things easy, which I guess they did as part of
a general policy or business aim or whatever of bringing people
~~together~~ to them. When everybody is busy scurrying all over the
place to assemble bits and pieces from here and there, being a one-stop
shop is a great way to become the go-to shop.

And that would be an understandable aim for any business, and an
understandable means of achieving it. Reduce friction by enabling people
to do more and more disparate and distinct things in one single place.

But the ease of this also encouraged people not to worry about the
details they used to have to worry about in order to fit the disparate
pieces together within their own bespoke workflows. That’s also a
process that has been effectively happening forever. Innovation very
often strives to make things easier. And often does so in ways that
don’t generally need to be reversed. It might be possible to go back,
but there’s no need.

In an era of mobile phones and wireless connectivity, nobody needs to
really know how a telephone exchange really works. Like now, in this
present moment. We’ve moved on. And it’s great that nerds still maintain
knowledge and ability to operate telephone exchanges, but the loss of
that knowledge would have relatively little direct effect on the
abilities of people throughout the world to keep on innovating,
extending, and enriching. And yet telephone exchanges still provide a
good starting point for this, so here we go.

### Telephone exchanges, multiplexing, and centralisation

Telephone exchanges were made obsolete because somebody came up with the
idea of “multiplexing” telephone lines. In the exchange era, every
connection between a pair of telephones was a single line. People pulled
plugs out and pushed them in to make those connections. They exchanged
the ends of cables. A “multiplex” was a way of combining many signals
together within a single line. Instead of each call flowing along a
dedicated line, a single line could be used to route multiple calls
simultaneously. Multiplexing made far more efficient use of the scarce
resource of telephone cables. It also needed de-multiplexers at the
other end to extract only the desired part of a signal.

One effect of multiplexing was increased centralisation. Telephone
switching systems were always hierarchical, and so always manifest their
own forms of centralisation. This was necessary to enable long-distance
calls to be switched ever upward from local, regional hubs to more
centralised ones controlling flows over entire regions, and back down on
the other side.

Multiplexing required physical multiplexers and demultiplexers. And
bigger multiplexers are more technically complex. The technical needs at
different hierarchical levels became (far) more pronounced. That
required a greater degree of centralisation, even if only for telephone
companies to be able to run the most central, technically advanced parts
of a multiplex hierarchy. And the benefits of greater centralisation
then fed back proportionally more to those companies able to centralise
the most. Which were naturally those companies that were already big
enough to do so. And so the technical advance of telephone multiplexers
centralised the entire telephone system both technically and
economically. And then further feedbacks between economics and politics
led to additional political centralisation of telephone systems, and so
on. Just one of many cases in which economies of scale[^2] combined with
efficiencies of technical centralisation to become inextricably coupled
with increased economic and political centralisation.

------------------------------------------------------------------------

The centralisation of telephone systems has been problematic in many
political areas throughout the world, but even in such places any
problems are likely viewed as a price worth paying for the technical
advances that started with multiplexing and end up with the internet
everywhere on your mobile phone.

But modern telephony was not just a technical development. It didn’t
take many words above to show that it was also an economic and political
development. Just because we might not wish for technical reversibility
doesn’t necessarily mean that economic or political reversibility might
not be desirable.

<div class="info-block">

To be clear: we’re talking about highly complex techno-politico-social
systems here, in which reversibility can only ever be approximate and
partial – see literature around the concept of [“causal
emergence”](https://arxiv.org/abs/2503.13395) for some great insights in
that regard. There can never be any complete or exact reversibility.

</div>

History has no “rewind” button. And that’s likely also a good thing.
Consider that the USA was a country which perhaps suffered some of the
worst effects of economic and political concentration of telephone
systems, and yet those selfsame ancillary effects of concentration also
fostered Bell Labs,
[CNET](https://en.wikipedia.org/wiki/Centre_national_d%27%C3%A9tudes_des_t%C3%A9l%C3%A9communications),
and all of the technical innovations these and other centralised
telephone research laboratories produced.

So the technological developments that started with multiplexing, and
which inexorably increased the centralisation of a complex host of
previously disparate economic and political entities and effects, ended
up with a wealth of ancillary and indubitably positive developments
which could never had been predicted had the foreseen negative effects
of centralisation been halted before they began.

And yet there were, and still are, negative effects of that
centralisation[^3] which deserve to be considered, and which can and
should be taken as cautionary tales in considering any perceived
centralisation of present-day technological developments. Purported
positive effects are also easy to overstate. Regardless of the positive
developments which emanated from Bell Labs, the modern smart phone was
not invented by a telephone corporation. Even though it surely should
have been if there were any truly positive relationship between scale
and technological innovation[^4].

Instead of progressive technological development from within
increasingly centralised telephone corporations, the technology remained
remarkably static over an unnecessarily long period of time, while the
economic and political power of increasingly monopolistic telcos
arguably stifled innovation while extracting maximal acceptable revenue
from “consumers” of these systems. Could this have been avoided?

\*

### Reversibility

It would be possible to reverse the technical advances of modern
telephony by recreating a physical exchange system, although it seems
fair to assume that very few people would want that. The internet can’t
be transmitted through a telephone exchange, for one. But modern
telephony is still a series of technically reversible developments.

What is not reversible are the economic and political effects that rode
alongside those technical developments. There are hosts of books written
on the general irreversibility of any centralisation of power[^5]. There
is no necessary relationship between technology and power, even though
the two are very often inextricable. And yet as soon as any new
technological development bestows power on those who control it, that
power will generally be used to [amass further
power](https://scholarship.law.columbia.edu/books/176/). That is a
process of centralisation, and centralisations of power are far less
reversible that centralisations of technology.

This suggests an immediate and glaring problem. Most technological
developments are inherently reversible. And most people directly
responsible for technological innovation are neither interested nor able
to directly amass power for themselves as a result of their personal
contributions to innovation (personal benefits for career progression
notwithstanding). The people who can amass power from technological
development are not those doing the actual development. Rather, the
power gatherers sit outside the centres of innovation, and merely act as
organisers, managers, or parasites, drawing upon the innovation of
others to amass their own power. And any people in such positions have a
vested interest in preventing any developments from being reversed, and
very generally wouldn’t know how to do so anyway[^6].

So reversibility becomes disconnected from development. Perhaps even
worse, recent technological developments often arise within systems
which have greatly eased abilities to technically reverse developments
(`git reset`, for example, to instantly take computer code back to any
arbitrary point in its history). This technical ease of reversing
developments likely encourages an effective ignorance of the true
consequences of the irreversibility of any effects associated with those
technological developments.

And so we have a profound cultural mismatch: Those most responsible for
the innovation that is defining much current “progress” doctrinally
ignore irreversibility, while simultaneously creating systems which have
profoundly irreversible social and political consequences.

------------------------------------------------------------------------

## The reversibility of GitHub

<div class="use-dropcap">

</div>

As I said at the start, all aspects of this blog used to held and served
by GitHub, long before they were swallowed up by Microsoft. After the
acquisition, GitHub tried very hard to centralise the entire world that
is computer programming. And they arguably did an okay job of that.

The founders of GitHub had long realised that the truly irreversible
aspect of centralisation for code hosting services was social. Social
networks were universally considered until relatively recently as truly
irreversible. Facebook has always assumed invincibility through
irreversibility. But Microsoft extended GitHub well beyond the social
network aspects alone, perhaps most notably through amassing an armada
of computers that anybody could call upon to conduct the kinds of checks
essential to modern software - the stuff which has come to be known as
“continuous integration.” Ever time code is updated on GitHub, it can be
configured to trigger a host of machines which check whether updates
break anything else within that code, within any other code which may
depend on it, or literally any other arbitrary thing anyone can think
of.

In the spirit of our present times, they did this with an intentional
aim of ~~destroying~~ out-competing a number of business which offered
these continuous integration services that ~~GitHub~~ Microsoft did not
initially offer. A few survived; a few didn’t. And GitHub won. They went
from just *hosting* code and the social networks surrounding code
development, to being the central place to host, check, publish, and
deploy code.

That’s a lot of moving pieces, many of which previously required people
to program interfaces between GitHub and other services. Nobody has to
do that any more (they get to giggle about GitHub actions instead).
People of course can and still do implement interfaces between the
distinct stops between developers writing a line of code and people
using some polished program or app. But GitHub made these processes so
easy that many people no longer have to do such things.

So GitHub actively strove for centralisation. But this was arguably
technical centralisation alone, much of which was and is technically and
practically reversible. Perhaps the only aspect of GitHub that remains
arguably irreversible is the original social network built long before
Microsoft’s acquisition. But Twitter has gone; Facebook is effectively
legacy software; and people can clearly up and move their social
networks elsewhere. No developments pursued by Microsoft made any
increase in GitHub’s centralisation any less reversible.

### On centralisation and interfaces

The current state of GitHub shows one clear disadvantage of
centralisation. Processes of connecting disparate pieces together in
central conglomerations require interfaces between those pieces. And
those interfaces become more complex as systems become more centralised.

The end result in the case of GitHub is [GitHub
actions](https://github.com/features/actions). An “action” is a file
with a highly GitHub-specific format that tells its machine what to do
with your software. These files are meaningless in any context other
than GitHub’s machines[^7]. The bits that remain independent of the
dictates and requirements of GitHub are the original bits that were
centralised through them building these increasingly arcane interfaces.
Your software as input, and your published website or whatever else as
output.

These interfaces are arcane because they are centralised. In attempting
to be as generalisable as possible across as many kinds of inputs and
outputs as possible, interfaces become unavoidably complicated.
Generality in centralised systems breeds complexity.

And yet the kinds of interfaces required to fit any two pieces
together - to transform one input to one output - are generally far
simpler. They just can’t be expressed in any simple way in such a highly
centralised system. The end result is that you can have all of your
stuff on GitHub, but the more stuff you put there, the more complicated
it gets to maintain interfaces between all the parts. GitHub could of
course strive for solutions to this problem of increasing interface
complexity, but it doesn’t even have any direct leadership[^8] at
present, so that’s unlikely to happen.

<div class="info-block">

Regardless of future trajectories of GitHub, I do suspect there is a
general and avoidable relationship between increasing centralisation and
the “thickness” of interfaces. Proposed solutions like
[modularity](https://direct.mit.edu/books/monograph/1856/Design-Rules-Volume-1The-Power-of-Modularity)
may ameliorate some effects, but I would like to think that in any
plausibly reversible system – in this context, one in which
reversibility is largely technical only – the inevitable
[coupling](https://arxiv.org/abs/2507.09599) of centralisation and
interface “thickness” should ultimately be self-defeating.

</div>

\*

## De-centralising

Moving this blog away from GitHub has been a very clear lesson in
exactly what I just described. The entire interface required to
transform the source code into the published result you’re reading now
is contained in [this very simple
file](https://codeberg.org/mpadge/mpadge/src/branch/source/statichost.yml).
It has only 3 lines of code: one to say what kind of system I want to
build it with; one to actually run the build command; and one to tell it
where to find the output.

The input is the source code for this site, which is [held in many
places](https://ropensci.org/blog/2025/12/17/beyond-github/). I’ve
configured [one of those places](https://codeberg.org/mpadge/mpadge)
with a webhook which triggers the build process over at
[statichost.eu](http://statichost.eu). But I can also just trigger that
locally, or move the webhook anywhere else, and I can just as easily
switch the build process from [statichost](http://statichost.eu) to
anywhere else. If and when I move any parts, I’ll likely need a new
interface to connect those. But replacing those 3 lines with some
alternative interface is so easy it won’t even be worth starting an AI
coding agent for that job.

De-centralising should be about simplifying interfaces as much as
possible. And it should also be evident from the generality of much of
what I’ve written here that I also believe in the general applicability
of that conclusion:

<div class="conclusion-block">

It’s not your bits and pieces, your software, your inputs and outputs,
that bind you to any one centralised place like GitHub, it’s the
interfaces that are forced upon you when you use that centralised place
to connect those bits and pieces. Simplifying interfaces is a vital step
towards decentralisation, and also one of the best ways to maintain
technical reversibility. And technical reversibility is a necessary
precondition to counter any processes of economic or political
centralisation.

</div>

[^1]: The way this site is now built has changed a lot since that
    original post, so much of it is now inaccurate.

[^2]: Almost all so-called “economies of scale” can be more accurately
    viewed as economies of centralisation. And yet generations of
    economists still learn about “economies of scale” rather than
    exploring the complexities of what really happens to produce an
    effect that makes it seem like the clearly perversely simplistic
    axiom “bigger is better.”

[^3]: Starting points that many people are fond of citing range from
    Alexis de Tocqueville’s *Democracy in America* (1835-1840) to
    Frederich Hayek’s anti-centralisation rant, *The road to serfdom*
    (1944).

[^4]: Continuing from two footnotes prior, if economies of scale really
    worked as proposed, then economies of innovation should also exist
    and work in the same way. Yet with innovation almost the exact
    opposite happens. Innovation may increase over enormous scales of
    entire urban conglomerates, but where that does happen, it is
    through much better understood mechanisms of network aggregation.
    There has never been any economy of innovation within any single
    organisation or company. Continued emphasis on “economies of scale”
    is, in that context, wilful ignorance.

[^5]: Including the countless books inspired by de Tocqueville, Hayek,
    and the masses who came after, even if most of them consider
    irreversibility more through the effect of centralisation being
    ineluctable. More nuanced and contextually relevant consideration is
    given in Tim Wu’s *The Master Switch: The Rise and Fall of
    Information Empires*, linked directly below.

[^6]: There is possibly some kind of relationship between hierarchy and
    reversibility here, which I know others have thought about far more
    than I have. Hierarchy entrenches institutional knowledge, so that
    every extra layer of management becomes an extra degree of
    irreversibility.

[^7]: You can also configure your own computer to become an exact clone
    of one of these machines, enabling you to use your computer instead
    of one of GitHub’s. But even then, you’re still entirely constrained
    by the way that GitHub has designed their own machines to work.

[^8]: No “CEO” as people love to say, and I’m really looking forward to
    a future time where we all laugh at how ridiculous all of these
    obfuscatory acronyms sound. “Boss” is a fabulous English word with a
    host of connotations, many of which are still eminently applicable.
    All this talk of “C-levels” and “C-suites” is nothing other than
    neologism with the sole intent of making it impossible to use these
    acronyms as verbs. ’‘*I’ve been totally C-levelled around!*’’

# Alfred docker cloud workflow

Allows you to quickly jump to stacks on the new docker cloud web interface.

![](https://dl.dropboxusercontent.com/u/1953503/Screenshots/alfred-docker-cloud.gif)

## Usage

For this workflow to do its work, you need to be logged in to docker with the docker's CLI. If you're using docker hub or docker cloud, you're likely logged in already and this workflow will just work. If not, just log in to docker like this:

```shell
$ docker login
```

### Jump to a stack

To see all stacks on your account enter

```
dc
```

and to jump to a specific stack, just enter part of its name after the `dc` keyword like so:

```
dc balancer
```

This will show all of your stacks with `balancer` in their name. Matching is done in a very primitive fuzzy manner, so you could find the stack `balancer-production` by searching for

```
dc balpro
```

It works a bit like the fuzzy file finder in vim's ctrl+p, atom, sublime, textmate, and so on.


### Switch betweeen organization and personal account

If you want to switch to an organization account on docker cloud (they call it a namespace), just enter:

```
dc-organization acmecorp
```

To switch back to your personal user account, just leave out the organization name:

```
dc-organization
```

### Refresh

You can manually force a refresh by entering

```
dc-refresh
```

## Troubleshooting

This works for me™, if something does not work for you, just let me know and I'll see if I can help.

## Contribute

I'm planning to add a node search as well, if you're missing features, just issue a PR with your idea :-)

## Source code

This project is hosted on github at [jayniz/alfred-dockercloud](https://github.com/jayniz/alfred-dockercloud). 

## Feedback

https://twitter.com/jannis

Tip'o'hat to [@edgarjs](https://twitter.com/edgarjs) because his [github alfred workflow](https://github.com/edgarjs/alfred-github-repos) was a great help in developing this workflow. Thank you, sir!

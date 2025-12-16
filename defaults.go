package main

import (
	"fmt"

	"github.com/adrg/xdg"
	"github.com/urfave/cli/v3"
)

func SetDefaults(c *cli.Command, p *Plugin) {
	if p.Pipeline.Event == "tag" && !c.IsSet("tags") {
		// tags clone not explicit set but pipeline is triggered by a tag
		// auto set tags cloning to true
		p.Config.Tags = true
	}

	if c.IsSet("tags") && c.IsSet("partial") {
		fmt.Println("WARNING: ignore partial clone as tags are fetched")
	}

	p.Config.Partial = false

	p.Config.Depth = 0

	if len(p.Config.Home) == 0 {
		// fallback to system home
		p.Config.Home = xdg.Home
	}
}

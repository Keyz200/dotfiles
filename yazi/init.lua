require("bunny"):setup({
  hops = {
    { key = "t",          path = "/tmp",                                 },
    { key = { "h", "h" }, path = "~",              desc = "Home"         },
    { key = "m", 		  path = "~/music",        desc = "Music"        },
    { key = "i", 		  path = "~/images",       desc = "Images"       },
    { key = "p", 		  path = "~/images/pictures", desc = "Pictures"  },
    { key = "w", 		  path = "~/images/wallpapers", desc = "Wallpapers"  },
    { key = { "d", "d" }, path = "~/documents",    desc = "Documents"    },
    { key = { "d", "e" }, path = "~/desktop",      desc = "Desktop"      },
    { key = { "d", "w" }, path = "~/downloads",    desc = "Downloads"    },
    { key = "c",          path = "~/.config",      desc = "Config files" },
    { key = "s",          path = "~/.config/scripts/", desc = "Scripts" },
    { key = "o",          path = "~/images/imagemagick/converter/images", desc = "Imagemagick" },
    { key = "l",          path = "~/.local/share", desc = "Local share"  },
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})


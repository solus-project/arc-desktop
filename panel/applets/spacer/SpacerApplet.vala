/*
 * This file is part of arc-desktop
 * 
 * Copyright (C) 2015 Ikey Doherty <ikey@solus-project.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

public class SpacerPlugin : Arc.Plugin, Peas.ExtensionBase
{
    public Arc.Applet get_panel_widget(string uuid)
    {
        return new SpacerApplet(uuid);
    }
}

public class SpacerApplet : Arc.Applet
{

    public int space_size { public set; public get; default = 5; }

    public string uuid { public set; public get; }

    private Settings? settings;

    public SpacerApplet(string uuid)
    {
        Object(uuid: uuid);

        settings_schema = "com.solus-project.spacer";
        settings_prefix = "/com/solus-project/arc-panel/instance/spacer";

        settings = this.get_applet_settings(uuid);
        settings.changed.connect(on_settings_change);
        on_settings_change("size");

        show_all();
    }

    void on_settings_change(string key)
    {
        if (key != "size") {
            return;
        }
        this.space_size = settings.get_int(key);
        queue_resize();
    }

    public override void get_preferred_width(out int min, out int nat)
    {
        min = nat = space_size;
    }

    public override void get_preferred_width_for_height(int h, out int min, out int nat)
    {
        min = nat = space_size;
    }
}


[ModuleInit]
public void peas_register_types(TypeModule module)
{
    // boilerplate - all modules need this
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type(typeof(Arc.Plugin), typeof(SpacerPlugin));
}

/*
 * Editor modelines  -  https://www.wireshark.org/tools/modelines.html
 *
 * Local variables:
 * c-basic-offset: 4
 * tab-width: 4
 * indent-tabs-mode: nil
 * End:
 *
 * vi: set shiftwidth=4 tabstop=4 expandtab:
 * :indentSize=4:tabSize=4:noTabs=true:
 */
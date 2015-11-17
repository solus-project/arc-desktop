/*
 * This file is part of arc-desktop
 * 
 * Copyright 2015 Ikey Doherty <ikey@solus-project.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

namespace Arc
{

public class Raven : Gtk.Window
{

    /* Use 15% of screen estate */
    private double intended_size = 0.15;

    int our_width = 0;
    int our_height = 0;

    private Arc.ShadowBlock? shadow;

    public Raven()
    {
        Object(type_hint: Gdk.WindowTypeHint.UTILITY, gravity : Gdk.Gravity.EAST);
        get_style_context().add_class("arc-container");

        var vis = screen.get_rgba_visual();
        if (vis == null) {
            warning("No RGBA functionality");
        } else {
            set_visual(vis);
        }

        /* Set up our main layout */
        var layout = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        add(layout);

        shadow = new Arc.ShadowBlock(PanelPosition.RIGHT);
        layout.pack_start(shadow, false, false, 0);

        /* Temporary */
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        layout.pack_start(box, true, true, 0);
        box.get_style_context().add_class("arc-panel");

        resizable = true;
        skip_taskbar_hint = true;
        skip_pager_hint = true;
        set_keep_above(true);
        set_decorated(false);

        shadow.realize.connect(()=> {
            var win = shadow.get_window();
            var disp = shadow.get_screen().get_display();
            win.set_cursor(new Gdk.Cursor.for_display(disp, Gdk.CursorType.SB_H_DOUBLE_ARROW));
        });
        shadow.button_press_event.connect((w,e)=> {
            if (e.button != 1) {
                return Gdk.EVENT_PROPAGATE;
            }
            this.begin_resize_drag(Gdk.WindowEdge.WEST, (int)e.button,(int) e.x_root, (int)e.y_root, e.get_time());
            return Gdk.EVENT_PROPAGATE;
        });
    }

    /**
     * Update our geometry based on other panels in the neighbourhood, and the screen we
     * need to be on */
    public void update_geometry(Gdk.Rectangle rect, Arc.Toplevel? top, Arc.Toplevel? bottom)
    {
        int width = (int) (rect.width * this.intended_size);
        int x = (rect.x+rect.width)-width;
        int y = rect.y;
        int height = rect.height;

        if (top != null) {
            int size = top.intended_size - top.shadow_depth;
            height -= size;
            y += size;
        }

        if (bottom != null) {
            height -= bottom.intended_size;
            height += bottom.shadow_depth;
        }

        our_height = height;
        our_width = width;
        move(x, y);
        queue_resize();
    }

    public override void get_preferred_width(out int m, out int n)
    {
        m = our_width;
        n = our_width;
    }

    public override void get_preferred_width_for_height(int h, out int m, out int n)
    {
        m = our_width;
        n = our_width;
    }

    public override void get_preferred_height(out int m, out int n)
    {
        m = our_height;
        n = our_height;
    }

    public override void get_preferred_height_for_width(int w, out int m, out int n)
    {
        m = our_height;
        n = our_height;
    }
}

} /* End namespace */
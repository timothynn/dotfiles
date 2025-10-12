#!/usr/bin/env python3
"""
Hyprland Keybinding Viewer
A GUI application to display all keybindings from Hyprland config
"""

import re
import os
import tkinter as tk
from tkinter import ttk, scrolledtext
import subprocess
from pathlib import Path

class KeybindViewer:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Hyprland Keybindings")
        self.root.geometry("800x600")
        
        # Set dark theme colors
        self.bg_color = "#1e1e2e"
        self.fg_color = "#cdd6f4"
        self.accent_color = "#89b4fa"
        self.secondary_bg = "#313244"
        
        self.setup_gui()
        self.load_keybindings()
        
    def setup_gui(self):
        # Configure root window
        self.root.configure(bg=self.bg_color)
        
        # Create main frame
        main_frame = tk.Frame(self.root, bg=self.bg_color)
        main_frame.pack(fill="both", expand=True, padx=10, pady=10)
        
        # Title
        title_label = tk.Label(
            main_frame,
            text="Hyprland Keybindings",
            font=("JetBrains Mono", 16, "bold"),
            bg=self.bg_color,
            fg=self.accent_color
        )
        title_label.pack(pady=(0, 10))
        
        # Search frame
        search_frame = tk.Frame(main_frame, bg=self.bg_color)
        search_frame.pack(fill="x", pady=(0, 10))
        
        tk.Label(
            search_frame,
            text="Search:",
            font=("JetBrains Mono", 10),
            bg=self.bg_color,
            fg=self.fg_color
        ).pack(side="left", padx=(0, 5))
        
        self.search_var = tk.StringVar()
        self.search_var.trace("w", self.filter_keybindings)
        search_entry = tk.Entry(
            search_frame,
            textvariable=self.search_var,
            font=("JetBrains Mono", 10),
            bg=self.secondary_bg,
            fg=self.fg_color,
            insertbackground=self.fg_color,
            relief="flat"
        )
        search_entry.pack(side="left", fill="x", expand=True)
        
        # Create notebook for categories
        self.notebook = ttk.Notebook(main_frame)
        self.notebook.pack(fill="both", expand=True)
        
        # Configure notebook style
        style = ttk.Style()
        style.theme_use('clam')
        style.configure('TNotebook', background=self.bg_color, borderwidth=0)
        style.configure('TNotebook.Tab', 
                       background=self.secondary_bg, 
                       foreground=self.fg_color,
                       padding=[12, 8])
        style.map('TNotebook.Tab',
                 background=[('selected', self.accent_color)],
                 foreground=[('selected', self.bg_color)])
        
        # Initialize categories
        self.categories = {
            "All": [],
            "Window Management": [],
            "Workspaces": [],
            "Applications": [],
            "System": [],
            "Media": [],
            "PyprLand": [],
            "Other": []
        }
        
        self.text_widgets = {}
        
    def create_text_widget(self, parent):
        """Create a styled text widget"""
        text_widget = scrolledtext.ScrolledText(
            parent,
            font=("JetBrains Mono", 10),
            bg=self.secondary_bg,
            fg=self.fg_color,
            insertbackground=self.fg_color,
            selectbackground=self.accent_color,
            selectforeground=self.bg_color,
            relief="flat",
            wrap="none"
        )
        
        # Configure scrollbar
        text_widget.vbar.configure(
            bg=self.secondary_bg,
            troughcolor=self.bg_color,
            activebackground=self.accent_color
        )
        
        return text_widget
        
    def parse_keybindings(self, config_path):
        """Parse keybindings from Hyprland config"""
        keybindings = []
        
        try:
            with open(config_path, 'r') as f:
                content = f.read()
                
            # Find mainMod definition
            main_mod_match = re.search(r'\$mainMod\s*=\s*(\w+)', content)
            main_mod = main_mod_match.group(1) if main_mod_match else "SUPER"
            
            # Parse bind statements
            bind_patterns = [
                r'bind\s*=\s*([^,]+),\s*([^,]+),\s*(.+)',
                r'bindm\s*=\s*([^,]+),\s*([^,]+),\s*(.+)',
                r'bindel\s*=\s*([^,]+),\s*([^,]+),\s*(.+)',
                r'bindl\s*=\s*([^,]+),\s*([^,]+),\s*(.+)'
            ]
            
            for pattern in bind_patterns:
                matches = re.findall(pattern, content, re.MULTILINE)
                for match in matches:
                    modifiers, key, action = match
                    
                    # Replace $mainMod
                    modifiers = modifiers.replace('$mainMod', main_mod).strip()
                    key = key.strip()
                    action = action.strip()
                    
                    # Clean up action (remove exec, and extra spaces)
                    if action.startswith('exec,'):
                        action = action[5:].strip()
                    
                    keybindings.append({
                        'modifiers': modifiers,
                        'key': key,
                        'action': action,
                        'full_key': f"{modifiers} + {key}" if modifiers else key
                    })
                    
        except FileNotFoundError:
            keybindings.append({
                'modifiers': '',
                'key': 'ERROR',
                'action': f'Config file not found: {config_path}',
                'full_key': 'ERROR'
            })
            
        return keybindings
        
    def categorize_keybinding(self, keybinding):
        """Categorize a keybinding based on its action"""
        action = keybinding['action'].lower()
        
        if any(word in action for word in ['workspace', 'movetoworkspace']):
            return "Workspaces"
        elif any(word in action for word in ['killactive', 'movefocus', 'movewindow', 'resizewindow', 'togglefloating', 'togglesplit', 'pseudo']):
            return "Window Management"
        elif any(word in action for word in ['terminal', 'kitty', 'firefox', 'rofi', 'dolphin', 'filemanager']):
            return "Applications"
        elif any(word in action for word in ['volume', 'brightness', 'playerctl', 'mute']):
            return "Media"
        elif 'pypr' in action or '$pypr' in action:
            return "PyprLand"
        elif any(word in action for word in ['exit', 'waybar', 'dpms']):
            return "System"
        else:
            return "Other"
            
    def load_keybindings(self):
        """Load and display keybindings"""
        # Try to find Hyprland config
        config_paths = [
            "/home/tim/.dotfiles/configs/hyprland/hyprland.conf",
            "~/.config/hypr/hyprland.conf",
            os.path.expanduser("~/.config/hypr/hyprland.conf")
        ]
        
        config_path = None
        for path in config_paths:
            expanded_path = os.path.expanduser(path)
            if os.path.exists(expanded_path):
                config_path = expanded_path
                break
                
        if not config_path:
            config_path = config_paths[0]  # Use first as fallback
            
        keybindings = self.parse_keybindings(config_path)
        
        # Categorize keybindings
        for kb in keybindings:
            category = self.categorize_keybinding(kb)
            self.categories[category].append(kb)
            self.categories["All"].append(kb)
            
        # Create tabs and populate with keybindings
        for category, bindings in self.categories.items():
            if bindings:  # Only create tab if there are bindings
                frame = tk.Frame(self.notebook, bg=self.bg_color)
                self.notebook.add(frame, text=f"{category} ({len(bindings)})")
                
                text_widget = self.create_text_widget(frame)
                text_widget.pack(fill="both", expand=True, padx=5, pady=5)
                
                self.text_widgets[category] = text_widget
                self.populate_text_widget(text_widget, bindings)
                
    def populate_text_widget(self, text_widget, keybindings):
        """Populate text widget with keybindings"""
        text_widget.delete(1.0, tk.END)
        
        # Sort keybindings by key combination
        sorted_bindings = sorted(keybindings, key=lambda x: x['full_key'])
        
        # Calculate column widths
        max_key_len = max(len(kb['full_key']) for kb in sorted_bindings) if sorted_bindings else 20
        key_width = max(max_key_len + 2, 25)
        
        # Header
        header = f"{'KEY COMBINATION':<{key_width}} │ ACTION\n"
        header += "─" * key_width + "─┼─" + "─" * 50 + "\n"
        text_widget.insert(tk.END, header)
        
        # Keybindings
        for kb in sorted_bindings:
            key_combo = kb['full_key']
            action = kb['action']
            
            # Truncate long actions
            if len(action) > 60:
                action = action[:57] + "..."
                
            line = f"{key_combo:<{key_width}} │ {action}\n"
            text_widget.insert(tk.END, line)
            
        text_widget.configure(state='disabled')
        
    def filter_keybindings(self, *args):
        """Filter keybindings based on search term"""
        search_term = self.search_var.get().lower()
        
        for category, text_widget in self.text_widgets.items():
            if category == "All":
                continue
                
            # Filter bindings for this category
            filtered_bindings = []
            for kb in self.categories[category]:
                if (search_term in kb['full_key'].lower() or 
                    search_term in kb['action'].lower() or
                    search_term in kb['key'].lower()):
                    filtered_bindings.append(kb)
                    
            # Update text widget
            text_widget.configure(state='normal')
            self.populate_text_widget(text_widget, filtered_bindings)
            
        # Update "All" tab
        if "All" in self.text_widgets:
            all_filtered = []
            for kb in self.categories["All"]:
                if (search_term in kb['full_key'].lower() or 
                    search_term in kb['action'].lower() or
                    search_term in kb['key'].lower()):
                    all_filtered.append(kb)
            
            text_widget = self.text_widgets["All"]
            text_widget.configure(state='normal')
            self.populate_text_widget(text_widget, all_filtered)
            
    def run(self):
        """Run the application"""
        self.root.mainloop()

def main():
    app = KeybindViewer()
    app.run()

if __name__ == "__main__":
    main()
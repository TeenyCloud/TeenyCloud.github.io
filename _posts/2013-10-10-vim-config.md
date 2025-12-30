---
title: "The best vim config (for me)"
description: "A set of plugins to turn Vim into the best IDE"
category: blog
tags: [Vim, Editor, Coding]
image: "assets/images/nerd-tree.jpg"
---

Some time ago, [I wrote about a Vim config](http://old-blog.teenycloud.com/2012/05/vim-configuration.html) which was more focused on Node.js. I used it in conjunction to [AutoComplPop](http://www.vim.org/scripts/script.php?script_id=1879) and a set of other plugins. However, I had to patch the auto-completion plugin for it to behave the way I wanted and it still didn't quite work the way I hoped (or I simply failed to use it correctly).

The other day, I stumbled upon a fairly recent article called [Equipping Vim for JavaScript](http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/) and it suggested a Vim config which is truly awesome. I encourage you to read the article.

My Vim config is now mostly based on this one + some additional plugins. Here it is.

# Pathogen

This is a pre-requisite.
[Pathogen](https://github.com/tpope/vim-pathogen) is a plugin to install plugins and runtime files in their own private directories. Through this separation of concern, it becomes really easy to manage plugins. All plugins will get installed in ~/.vim/bundle/. This is convenient and will look like:

{% highlight text %}
.vim/
|
+- autoload/
|
+- bundle/
| |
| +- Plugin-A
| |
| +- Plugin B
| |
| +- etc..
|
+- etc..
{% endhighlight %}

In practice, I recommend to install all "bundle" in a directory called bundle-available and to link (ln -s) from bundle to bundle-available. This will allow to de-activate temporarily a bundle very easily if need be.

# YouCompleteMe

This plugin is a life changer. It really turns Vim into an IDE.

It enables as-you-type code completion with several completion engines built-in. In particular for C/C++/Objective-C/Objective-C++ languages, it relies on Clang making it breathtaking. It also has support for Python and C#. There is no built-in support for JavaScript but we will "fix" this in a moment. You can grab YouCompleteMe on [Github](https://github.com/Valloric/YouCompleteMe). You won't regret it.

![YCM in action`]({{ site.url }}/assets/images/ycm-vim.jpg)
{: .img-pull-right}

The installation is very well detailed. It is not just a "git clone" and requires to compile some extras (including Clang) but it is easy and definitely worth it.

# Tern For Vim

This plugin provides [Tern](http://ternjs.net/)-based Javascript editing support to Vim. In particular, it works nicely with YouCompleteMe as it hooks into the Vim omni-completion feature. Tern being a javascript program, it requires Node.js and npm. Once installed, simply hit "npm install". Everything is explained on the [GitHub page](https://github.com/marijnh/tern_for_vim).

So go get Tern for Vim if you need Javascript.

# Syntastic

Next is [Syntastic](https://github.com/scrooloose/syntastic).

As the name implies, syntastic is a syntax checking plugin. By itself, it does not have the capability to check the syntax for all languages. Rather it relies on external syntax checker and then display the errors nicely in Vim.

The best part if you are editing C-family languages is YouCompleteMe's integration with syntastic. Because YouCompleteMe uses Clang as a backend, it also benefits to Syntastic for the C/C++/Obj-C/Obj-C++ syntax checking. Simply amazing. A must.

Please note that with JsHint (and most of the checkers I assume), the checks are triggered when the file is written to disk.

# DelimitMate

[DelimitMate](https://github.com/Raimondi/delimitMate) is the kind of plugin that once you use it, you don't know how you did before without it.
It simply provides automatic closing of quotes, brackets, etc... It is simple yet a must. Try it, you'll love it !

To nicely break lines once a {} is inserted, you can add the following mapping to your .vimrc as suggested by the author of [Equipping Vim for Javascript](http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/)

{% highlight vim %}
inoremap <C-c> <CR><Esc>O
{% endhighlight %}

Thanks to this mapping, hitting Ctrl-C will insert a carriage return and insert a new line above. When the cursor is in the middle of {} in INSERT mode, this will do just what you expect.

Alternatively, I suggest to remap the \<enter\> key in INSERT mode to do this automatically in case of brackets or parenthesis. This way, hitting \<enter\> will do the trick. Add this to your .vimrc:

{% highlight vim %}
"BreakLine: Return TRUE if in the middle of {} or () in INSERT mode
fun BreakLine()
if (mode() == 'i')
return ((getline(".")[col(".")-2] == '{' && getline(".")[col(".")-1] == '}') ||
\(getline(".")[col(".")-2] == '(' && getline(".")[col(".")-1] == ')'))
else
return 0
endif
endfun

" Remap <Enter> to split the line and insert a new line in between if
" BreakLine return True
inoremap <expr> <CR> BreakLine() ? "<CR><ESC>O" : "<CR>"
{% endhighlight %}

# TComment

Because commenting out is tiring, there is a plugin for that: [tComment](https://github.com/tomtom/tcomment_vim).

This plugin will provide file-type sensible toggling comments for Vim. And it just works great.
The primary key maps are not really convenient to me so I remapped some of them:

{% highlight vim %}
"Toggle comments
nmap <leader>c :TComment<CR>
"Toggle comments as a block
nmap <leader>= :TCommentBlock<CR>
{% endhighlight %}

And the same in VISUAL mode:

{% highlight vim %}
vmap <leader>c :TComment<CR>
vmap <leader>= :TCommentBlock<CR>
{% endhighlight %}

# NERD Tree

Thanks to NERD Tree, I don't use anymore ":Explore" or ":Sexplore".

The NERD Tree allows you to explore files in a very nice way. It splits the window and displays the tree at the left of the buffer in edit. An image is worth a hundred words:

<figure style="text-align:center">
	<img src="{{ site.url }}/assets/images/nerd-tree.jpg">
	<figcaption>Notice the syntax error highlighted by Syntastic</figcaption>
</figure>

Installation is just a "git clone" away ;-)

# Command T

[Command T](https://wincent.com/products/command-t) is a plugin that allows to open file with a minimal number of keystrokes.
It is extremely powerful and convenient and can be customized. This will soon be the only command you will use to open files.

There is a mode to search among files opened in buffers instead of looking on the disk. This is the fastest and easiest way to switch between buffers.
The GitHub repo is [here](https://github.com/wincent/Command-T).

Here is the mapping I use:

{% highlight vim %}
"CommandT
nmap <leader>e :CommandT<CR>
nmap <leader>b :CommandTBuffer<CR>
{% endhighlight %}

# Vim Indent Guides

![Vim Indent Guides]({{ site.url }}/assets/images/vim-indent-guide.jpg)
{: .img-pull-right}
This plugins is very useful: it highlights indentation level. For Python development, no way around ;-) and very handy for any other languages. The coloration is picked up automatically by the plugin depending on your color scheme. That did not work for me but you have the ability to override it.

Available [here](https://github.com/nathanaelkane/vim-indent-guides).

# JavaScript Syntax

[vim-javascript-syntax](https://github.com/jelera/vim-javascript-syntax) will make your javascript code look good thanks a very nice syntax-aware highlighting.

# JavaScript Indentation

[vim-javascript](https://github.com/pangloss/vim-javascript) is a very nice plugin to get the Javascript indentation right. I used web-indent in the past and I now use this one.

# CSS3

Two plugins that I have tried and that seem to be doing a pretty good job:

- [vim-css-color](https://github.com/skammer/vim-css-color) which underlays the hex color codes with their real color. Quite useful.
- [vim-css3-syntax](https://github.com/hail2u/vim-css3-syntax) add CSS3 syntax support to Vim.

And because [less](http://lesscss.org/) is awesome and you want to use less:

- [vim-less](https://github.com/groenewege/vim-less) is for you !

---

## Happy Vimming !

---

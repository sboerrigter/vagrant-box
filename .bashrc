# Login directory
cd /var/www

# Aliases
alias ar="sudo service apache2 restart"

alias pd="bundle exec cap production deploy"
alias pgd="bundle exec cap production wpcli:db:pull"
alias ppd="bundle exec cap production wpcli:db:push"
alias pgu="bundle exec cap production wpcli:uploads:rsync:pull"
alias ppu="bundle exec cap production wpcli:uploads:rsync:push"
alias pcc="bundle exec cap production opcache:clear && bundle exec cap production varnish:clear"

alias sd="bundle exec cap staging deploy"
alias sgd="bundle exec cap staging wpcli:db:pull"
alias spd="bundle exec cap staging wpcli:db:push"
alias sgu="bundle exec cap staging wpcli:uploads:rsync:pull"
alias spu="bundle exec cap staging wpcli:uploads:rsync:push"
alias scc="bundle exec cap staging opcache:clear && bundle exec cap staging varnish:clear"

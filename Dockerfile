FROM openemr/openemr:7.0.1

COPY composer.json /var/www/htdocs/

WORKDIR /var/www/htdocs

EXPOSE 80

CMD ["apache2-foreground"]

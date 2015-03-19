[%
    sub_header = [];
    FOREACH k IN [ 'price', 'price_RU', 'size', 'header' ];
        sub_header.push( data( k ) ) IF data( k );
    END;
    sub_header.join(' / ');
%]

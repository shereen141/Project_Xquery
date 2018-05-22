<r> 
Ques1: Print the number of items listed on all continents.
Sol:
        {
        for $x in doc("auction.xml")/site/regions/*
        return string(<count>&#xa;{count($x/item)}</count>)
        }

Ques2: List the names of items registered in Europe along with their descriptions.
Sol:    
        {
            for $x in doc("auction.xml")/site/regions/europe//item
            return string(<item>&#xa;<name>Name: {$x/name/text()}</name>&#xa;<description>Description: {$x/description}</description>&#xa;</item>)
        }    
Ques 3: List the names of persons and the number of items they bought.
Sol:
        {
            for $x in distinct-values(doc("auction.xml")/site/closed_auctions/closed_auction/buyer/@person)
            return ($x, count(index-of(doc("auction.xml")/site/closed_auctions/closed_auction/buyer/@person, $x)), '&#xa;')
        }

Ques 4: List all persons according to their interest (ie, for each interest category, display the persons on that category).
Sol:
    
        {
           for $x in doc("auction.xml")/site/categories/category/@id
            let $value := doc("auction.xml")/site/people/person[profile/interest/@category = $x]/name
            return (string(data(doc("auction.xml")/site/categories/category/name)),$value,'&#xa;')
        }

Ques 5: Group persons by their categories of interest and output the size of each group.
Sol:
        {
            for $x in doc("auction.xml")/site/people/person
            let $value := $x/profile/interest
            group by $x/profile/interest[1]/@category
            where exists($x/profile/interest/@category) = true
            return  ({count($x/name)}, '&#032;', {distinct-values(data($value/@category))}, '&#xa;')
        }
Ques 6: List the names of persons and the names of the items they bought in Europe.
Sol:    
        {
            for $x in doc("auction.xml")/site/regions/europe/item
            for $y in doc("auction.xml")/site/closed_auctions/closed_auction
            for $z in doc("auction.xml")/site/people/person
            where ($x/@id = $y/itemref/@item) and ($y/buyer/@person = $z/@id)
            return string(<item>&#xa;Item name:<itemname>&#xa;{$x/name/text()}</itemname><personname>&#xa;Person name:{$z/name/text()}</personname></item>)
    }
Ques 7: Give an alphabetically ordered list of all items along with their location.
Sol:
        {
            for $x in doc("auction.xml")/site/regions//item
            order by $x/name
            return string(<item>&#xa;Name:<name>{$x/name/text()}</name>&#xa;Location: <location>{$x/location/text()}</location>&#xa;</item>)
        }
Ques 8: List the reserve prices of those open auctions where a certain person with id person3 issued a bid before another person with id person6. (Here before means "listed before in the XML document", that is, before in document order.)
Sol:
        {
            for $x in doc("auction.xml")/site/open_auctions//open_auction
                let $y:= $x/bidder/personref/@person
                let $z:= compare('index-of($y,"person3")','index-of($y,"person6")')
                where $z = -1
                
                return ({$x/reserve/text()},'&#xa;')
            }
        </r>
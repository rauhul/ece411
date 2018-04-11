#############################################################################
##
#A  fpsgpres.g                GAP library                      Volkmar Felsch
##
#H  @(#)$Id: fpsgpres.g,v 3.9.1.3 1996/09/12 13:52:04 mschoene Exp $
##
#Y  Copyright 1990-1992,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  This file contains functions that compute presentations of  subgroups  of
##  finitely presented groups.
##
#H  $Log: fpsgpres.g,v $
#H  Revision 3.9.1.3  1996/09/12 13:52:04  mschoene
#H  fixed handling of abelian invariants
#H
#H  Revision 3.9.1.2  1995/11/25 15:51:34  mschoene
#H  cleaned up the handling of involutory generators
#H
#H  Revision 3.9.1.1  1994/08/22  09:46:33  vfelsch
#H  extended AbelianInvariantsSubgroupFpGroup and PresentationSubgroup
#H
#H  Revision 3.9  1994/05/27  08:32:39  vfelsch
#H  fixed function AugmentedCosetTableMtc
#H
#H  Revision 3.8  1993/10/27  09:54:31  felsch
#H  calls of FpGroupInfo1 fixed
#H
#H  Revision 3.7  1993/08/24  10:05:46  felsch
#H  correction for 'Size' via monomial representation
#H
#H  Revision 3.6  1993/07/30  09:27:34  martin
#H  added the functions for the Abelianized Reidemeister-Schreier method
#H
#H  Revision 3.5  1993/07/30  09:04:15  martin
#H  changed the relative order of the functions
#H
#H  Revision 3.4  1993/07/30  08:35:38  martin
#H  added the changes for the new 'ApplyRel' call
#H
#H  Revision 3.3  1993/03/10  19:15:53  fceller
#H  added 'EuclideanQuotient', 'EuclideanRemainder' and 'QuotientRemainder'
#H
#H  Revision 3.2  1993/02/09  14:25:55  martin
#H  made undefined globals local
#H
#H  Revision 3.1  1993/01/18  18:56:34  martin
#H  initial revision under RCS
#H
##


#############################################################################
##
#F  FpGroupOps.FpGroup(<U>) . . . . . . . . create a fp group from a subgroup
##
FpGroupOps.FpGroup := function ( U )
    local  pres;
    pres := PresentationSubgroup( Parent(U), U );
    pres.printLevel := 0;
    SimplifyPresentation( pres );
    return FpGroupPresentation( pres );
end;


#############################################################################
##
#F  PresentationSubgroupMtc(<G>, <H> [,<string>] [,<print level>] ) . . . . .
#F                                               Tietze record for a subgroup
##
##  'PresentationSubgroupMtc' uses the Modified Todd-Coxeter coset represent-
##  ative enumeration method  to compute a presentation  (i.e. a presentation
##  record) for a subgroup H of a finitely presented group G.  The generators
##  in the resulting presentation will be named   <string>1, <string>2, ... ,
##  the default string is "_x".  The default print level is  1.  If the print
##  level is set to 0,  then the printout of the 'DecodeTree' command will be
##  suppressed.
##
PresentationSubgroupMtc := function ( arg )

    local aug, G, H, i, printlevel, string, T, type;

    # check the first two arguments to be a finitely presented group and a
    # subgroup of that group.
    G := arg[1];
    if not ( IsRec( G ) and IsBound( G.isFpGroup ) and G.isFpGroup ) then
        Error( "<group> must be a finitely presented group" );
    fi;
    H := arg[2];
    if not ( IsRec( H ) and IsBound( H.isFpGroup ) and H.isFpGroup ) then
        Error( "<subgroup> must be a finitely presented group" );
    fi;
    if IsBound( H.parent ) and H.parent <> G or ( not IsBound( H.parent ) )
        and H <> G then
        Error( "<group> must be the parent of <subgroup>" );
    fi;

    # initialize generator name string and the print level.
    string := "_x";
    printlevel := 1;

    # get the optional parameters.
    for i in [ 3 .. 4 ] do
        if Length( arg ) >= i then
            if IsInt( arg[i] ) then printlevel := arg[i];
            elif IsString( arg[i] ) then string := arg[i];
            else
                Error( "optional parameter must be a string or an integer" );
            fi;
        fi;
    od;

    # do a Modified Todd-Coxeter coset representative enumeration to
    # construct an augmented coset table of H.
### if Length( H.generators ) = 1 then
### type := 1;
### else
    type := 2;
### fi;
    aug := AugmentedCosetTableMtc( G, H, type, string );

    # determine a set of subgroup relators.
    if type = 2 then
        RewriteSubgroupRelators( aug );
    fi;

    # create a Tietze record for the resulting presentation.
    T := PresentationAugmentedCosetTable( aug );
    if printlevel >= 1 then  TzPrintStatus( T, true );  fi;

    # decode the subgroup generators tree.
    InfoFpGroup1( "#I  calling DecodeTree\n" );
    T.printLevel := printlevel;
    DecodeTree( T );
    T.printLevel := 1;

if type = 1 then
if aug.exponent > 0 then Print( "size = ", aug.exponent * H.index, "\n" );
else Print( "size = infinite\n" ); fi;
### return aug;
fi;

    return T;
end;


#############################################################################
##
#F  AugmentedCosetTableMtc( <G>, <H>, <type>, <string> ) . . .  do an MTC and
#F                                           return the augmented coset table
##
##  'AugmentedCosetTableMtc' applies a Modified Todd-Coxeter coset represent-
##  ative  enumeration  to construct  an augmented coset table  for the given
##  subgroup  H  of  G.  The  subgroup generators  will be  named  <string>1,
##  <string>2, ... .
##
##  Valid types are  1 (for the one generator case),  0 (for the  abelianized
##  case),  and  2 (for the general case).  A type value of  -1 is handled in
##  the same way as the case type = 1,  but the function will just return the
##  index H.index of the given cyclic subgroup, and its exponent aug.exponent
##  as the only component of the resulting record aug.
##
if not IsBound( CosetTableFpGroupDefaultLimit )  then
    CosetTableFpGroupDefaultLimit := 1000;
fi;
if not IsBound( CosetTableFpGroupDefaultMaxLimit )  then
    CosetTableFpGroupDefaultMaxLimit := 64000;
fi;

AugmentedCosetTableMtc := function ( G, H, ttype, string )

    local   next,  prev,            # next and previous coset on lists
            fact,                   # factor to previous coset rep
            firstFree,  lastFree,   # first and last free coset
            firstDef,   lastDef,    # first and last defined coset
            firstCoinc, lastCoinc,  # first and last coincidence coset
            table,                  # coset table to be built up
            coFacTable,             # coset factor table
            rels,                   # representatives for the relators
            relsGen,                # relators sorted by start generator
            subgroup,               # rows for the subgroup gens
            tree,                   # tree of generators
            tree1, tree2,           # components of tree of generators
            treelength,             # number of gens (primary + secondary)
            type,                   # type
            deductions,             # deduction queue
            i, gen, inv,            # loop variables for generators
            g, f,                   # loop variables for generator cols
            rel,                    # loop variables for relation
            p, p1, p2,              # generator position numbers
            app,                    # arguments list for 'MakeConsequences2'
            limit,                  # limit of the table
            maxlimit,               # maximal size of the table
            j,                      # integer variable
            length, length2,        # length of relator
            cols,                   #
            gen,                    #
            nums,                   #
            l,                      #
            nrdef,                  # number of defined cosets
            nrmax,                  # maximal value of the above
            nrdel,                  # number of deleted cosets
            nrinf,                  # number for next information message
            numgens,                # number of generators
            gens,                   # new generators
            defs,                   # definitions of primary subgroup gens
            index,                  # index of H in G
            genname,                # name string
            numcols,                # number of columns in the tables
            numoccs,                # number of gens which occur in the table
            occur,                  #
            treeNums,               #
            exponent,               # order of subgroup in case type = 1
            aug;                    # augmented coset table

    # check the arguments
    if not IsParent( G )  or G <> Parent( H )  then
        Error( "<G> must be the parent group of <H>" );
    fi;

    # check the given type for being -1, 0, 1, or 2.
    if ttype < -1 or ttype > 2 then
        Error( "invalid type value; it should be -1, 0, 1, or 2" );
    fi;
    type := ttype;
    if type = -1 then type := 1; fi;

    # check the number of generators and the type for being consistent.
    numgens := Length( H.generators );
    if type = 1 and numgens > 1 then
        Error( "type 1 is illegal for more than 1 generators" );
    fi;

    # give some information
    InfoFpGroup2( "#I  ", "AugmentedCosetTableMtc called:\n" );
    InfoFpGroup2( "#I      defined deleted alive   maximal\n");
    nrdef := 1;
    nrmax := 1;
    nrdel := 0;
    nrinf := 1000;

    # initialize size of the table
    limit := CosetTableFpGroupDefaultLimit;
    maxlimit := CosetTableFpGroupDefaultMaxLimit;

    # define one coset (1)
    firstDef  := 1;  lastDef  := 1;
    firstFree := 2;  lastFree := limit;

    # make the lists that link together all the cosets
    next := [ 2 .. limit+1 ];  next[1] := 0;  next[limit] := 0;
    prev := [ 0 .. limit-1 ];  prev[2] := 0;
    fact := [ 1 .. limit ];  fact[1] := 0;  fact[2] := 0;

    # get the representatives of the relators
    rels := RelatorRepresentatives( G.relators );

    # make the columns for the generators
    table := [ ];
    coFacTable := [ ];
    for gen  in G.generators  do
        g := 0 * [ 1 .. limit ];
        f := 0 * [ 1 .. limit ];
        Add( table, g );
        Add( coFacTable, f );
        if not (gen^2 in rels or gen^-2 in rels)  then
            g := 0 * [ 1 .. limit ];
            f := 0 * [ 1 .. limit ];
        fi;
        Add( table, g );
        Add( coFacTable, f );
    od;

    # construct the list relsGen which for each generator or inverse
    # generator contains a list of all cyclically reduced relators,
    # starting with that element, which can be obtained by conjugating or
    # inverting given relators. The relators in relsGen are represented as
    # lists of the coset table columns corresponding to the generators and,
    # in addition, as lists of the respective column numbers.
    relsGen := RelsSortedByStartGen( G.generators, rels, table );

    # make the rows for the subgroup generators
    subgroup := [ ];
    for rel  in H.generators  do
        length := LengthWord( rel );
        length2 := 2 * length;
        nums := 0 * [1 .. length2];
        cols := 0 * [1 .. length2];

        # compute the lists.
        i := 0;  j := 0;
        while i < length do
            i := i + 1;  j := j + 2;
            gen := Subword( rel, i, i );
            p := Position( G.generators, gen );
            if p = false then
                p := Position( G.generators, gen^-1 );
                p1 := 2 * p;
                p2 := 2 * p - 1;
            else
                p1 := 2 * p - 1;
                p2 := 2 * p;
            fi;
            nums[j]   := p1;  cols[j]   := table[p1];
            nums[j-1] := p2;  cols[j-1] := table[p2];
        od;
        Add( subgroup, [ nums, cols ] );
    od;

    # define names for the (primary) subgroup generators.
    gens := [ ];
    defs := [ ];
    for i in [ 1 .. numgens ] do
        genname := ConcatenationString( string, StringInt( i ));
        gens[i] := AbstractGenerator( genname );
        defs[i] := H.generators[i];
    od;

    # initialize the tree of secondary generators.
    if type = 1 then
###     treelength := 0;
###     tree1 := 0;
###     tree2 := 0;
        treelength := 1;
        tree1 := [ 1 ];
        tree2 := [ 0 ];
    elif type = 0 then
        treelength := numgens;
        length := treelength + 100;
        tree1 := 0 * [ 1 .. length ];
        for i in [ 1 .. numgens ] do
            tree1[i] := 0 * [ 1 .. i ];
            tree1[i][i] := 1;
        od;
        tree2 := 0 * [ 1 .. numgens ];
    else
        treelength := numgens;
        length := treelength + 100;
        tree1 := 0 * [ 1 .. length ];
        tree2 := 0 * [ 1 .. length ];
    fi;
    tree := [ tree1, tree2, treelength, numgens, type ];

    # add an empty deduction list
    deductions := [ ];

    # initialize the subgroup exponent (which is needed in case type = 1)
    exponent := 0;
    if type = 1 then
        i := Position( G.generators, H.generators[1] );
        if i <> false then
            if IsIdentical( table[2*i-1], table[2*i] ) then
                exponent := 2;
            fi;
        fi;
    fi;

    # make the structure that is passed to 'MakeConsequences2'
    app := 0 * [ 1 .. 16 ];
    app[1] := table;
    app[2] := next;
    app[3] := prev;
    app[4] := relsGen;
    app[5] := subgroup;
    app[12] := coFacTable;
    app[13] := fact;
    app[14] := tree;
    app[15] := numgens;
    app[16] := exponent;

    # run over all the cosets
    while firstDef <> 0  do

        # run through all the rows and look for undefined entries
        for i  in [ 1 .. Length( table ) ]  do
            gen := table[i];

            if gen[firstDef] = 0  then

                inv := i + 2*(i mod 2) - 1;

                # if necessary expand the table
                if firstFree = 0  then
                    if 0 < maxlimit and  maxlimit <= limit  then
                        maxlimit := Maximum(maxlimit*2,limit*2);
                        Error( "the coset enumeration has defined more ",
                               "than ", limit, " cosets:\ntype 'return;' ",
                               "if you want to continue with a new limit ",
                               "of ", maxlimit, " cosets,\ntype 'quit;' ",
                               "if you want to quit the coset ",
                               "enumeration,\ntype 'maxlimit := 0; return;'",
                               " in order to continue without a limit,\n" );
                    fi;
                    next[2*limit] := 0;
                    prev[2*limit] := 2*limit-1;
                    fact[2*limit] := 0;
                    for g  in table  do g[2*limit] := 0;  od;
                    for g  in coFacTable  do g[2*limit] := 0;  od;
                    for l  in [limit+2..2*limit-1]  do
                        next[l] := l+1;
                        prev[l] := l-1;
                        fact[l] := 0;
                        for g  in table  do g[l] := 0;  od;
                        for g  in coFacTable  do g[l] := 0;  od;
                    od;
                    next[limit+1] := limit+2;
                    prev[limit+1] := 0;
                    fact[limit+1] := 0;
                    for g  in table  do g[limit+1] := 0;  od;
                    for g  in coFacTable  do g[limit+1] := 0;  od;
                    firstFree := limit+1;
                    limit := 2*limit;
                    lastFree := limit;
                fi;

                # update the debugging information
                nrdef := nrdef + 1;
                if nrmax <= firstFree  then
                    nrmax := firstFree;
                fi;

                # define a new coset
                gen[firstDef]              := firstFree;
                coFacTable[i][firstDef]    := 0;
                table[inv][firstFree]      := firstDef;
                coFacTable[inv][firstFree] := 0;
                next[lastDef]              := firstFree;
                prev[firstFree]            := lastDef;
                fact[firstFree]            := 0;
                lastDef                    := firstFree;
                firstFree                  := next[firstFree];
                next[lastDef]              := 0;

                # set up the deduction queue and run over it until it's empty
                app[6]  := firstFree;
                app[7]  := lastFree;
                app[8]  := firstDef;
                app[9]  := lastDef;
                app[10] := i;
                app[11] := firstDef;
                nrdel := nrdel + MakeConsequences2( app );
                firstFree := app[6];
                lastFree  := app[7];
                firstDef  := app[8];
                lastDef   := app[9];

                # give some information
                while nrinf <= nrdef+nrdel  do
                    InfoFpGroup2( "#I\t", nrdef, "\t", nrinf-nrdef, "\t",
                                          2*nrdef-nrinf, "\t", nrmax, "\n" );
                    nrinf := nrinf + 1000;
                od;

            fi;
        od;

        firstDef := next[firstDef];
    od;

    InfoFpGroup2( "#I\t", nrdef, "\t", nrdel, "\t",
                          nrdef-nrdel, "\t", nrmax, "\n" );

    # In case of type = -1 return just index and exponent of the given cyclic
    # subroup.
    if ttype = -1 then
        H.index := nrdef - nrdel;
        InfoFpGroup1( "#I  index = ", H.index, "  total = ", nrdef,
            "  max = ", nrmax, "\n" );
        aug := rec( );
        exponent := app[16];
        if exponent = 0 then
            exponent := "infinity";
        elif exponent < 0 then
            exponent := - exponent;
        fi;
        aug.exponent := exponent;
        return aug;
    fi;

    # standardize the table
    StandardizeTable2( table, coFacTable );

    # save coset table and index in the group record of H.
    if not IsBound( H.cosetTable ) then
        H.cosetTable := table;
    fi;
    index := Length( table[1] );
    if not IsBound( H.index ) then
        H.index := index;
        InfoFpGroup1( "#I  index = ", index, "  total = ", nrdef, "  max = ",
            nrmax, "\n" );
    fi;
    if H.index <> index then
        Error( "inconsistent values for the index of H in G" );
    fi;

    if type = 2 then

        # reduce the tree to its proper length.
        treelength := tree[3];
        length := Length( tree1 );
        while length > treelength do
            Unbind( tree1[length] );
            Unbind( tree2[length] );
            length := length - 1;
        od;

        # determine which generators occur in the augmented table.
        occur := 0 * [ 1 .. treelength ];
        for i in [ 1 .. numgens ] do
            occur[i] := 1;
        od;
        numcols := Length( coFacTable );
        numoccs := numgens;
        i := 1;
        while i < numcols do
            for next in coFacTable[i] do
                if next <> 0 then
                    j := AbsInt( next );
                    if occur[j] = 0 then
                        occur[j] := 1;  numoccs := numoccs + 1;
                    fi;
                fi;
            od;
            i := i + 2;
        od;

        # build up a list of pointers from the occurring generators to the
        # tree, and define names for the occurring secondary generators.
        if numoccs > numgens then
            gens[numoccs] := 0;
        fi;
        treeNums := [ 1 .. numoccs ];
        i := numgens;
        for j in [ numgens+1 .. treelength ] do
            if occur[j] <> 0 then
                i := i + 1;
                genname := ConcatenationString( string, StringInt( i ) );
                gens[i] := AbstractGenerator( genname );
                treeNums[i] := j;
            fi;
        od;
    fi;

    # create the augmented coset table record.
    aug := rec( );
    aug.isAugmentedCosetTable := true;
    aug.type := type;
    aug.groupGenerators := G.generators;
    aug.groupRelators := G.relators;
    aug.cosetTable := table;
    aug.cosetFactorTable := coFacTable;
    aug.primaryGeneratorWords := defs;
    aug.subgroupGenerators := gens;
    aug.tree := tree;

    if type = 1 then
        exponent := app[16];
        if exponent = 0 then
            aug.exponent := "infinity";
            aug.subgroupRelators := [ [ ] ];
        else
            if exponent < 0 then  exponent := - exponent;  fi;
            aug.exponent := exponent;
            aug.subgroupRelators := [ 0 * [ 1 .. exponent ] + 1 ];
        fi;
    elif type = 2 then
        aug.treeNumbers := treeNums;
    fi;

    # display a message
if treelength > 0 then
    InfoFpGroup1( "#I  MTC defined ", numgens, " primary and ",
        treelength - numgens, " secondary subgroup generators\n" );
fi;

    # return the augmented coset table.
    return aug;
end;


#############################################################################
##
#F  CheckCosetTableFpGroup( <G>, <table> ) . . . . . . . checks a coset table
##
##  'CheckCosetTableFpGroup'  checks whether  table is a legal coset table of
##  the finitely presented group G.
##
CheckCosetTableFpGroup := function ( G, table )

    local i, id, index, ngens, perms;

    # check G to be a finitely presented group.
    if not ( IsRec( G ) and IsBound( G.isFpGroup ) and G.isFpGroup ) then
        Error( "<G> must be a finitely presented group" );
    fi;

    # check table to be a list of lists.
    if not ( IsList( table ) and ForAll( table, IsList ) ) then
        Error( "<table> must be a coset table" );
    fi;

    # check the number of columns against the number of group generators.
    ngens := Length( G.generators );
    if Length( table ) <> 2 * ngens then
        Error( "inconsistent number of group generators and table columns" );
    fi;

    # check the columns to be permutations of equal degree.
    index := Length( table[1] );
    perms := 0 * [ 1 .. ngens ];
    for i in [ 1 .. ngens ] do
        if Length( table[2*i-1] ) <> index then
            Error( "table has columns of different length" );
        fi;
        perms[i] := PermList( table[2*i-1] );
        if PermList( table[2*i] ) <> perms[i]^-1 then
            Error( "table has inconsistent inverse columns" );
        fi;
    od;

    # check the permutations to act transitively.
    id := perms[1]^0;
    if not IsTransitive( Group( perms, id ), [ 1 .. index ] ) then
        Error( "table does not act transitively" );
    fi;

    # check the permutations to satisfy the group relators.
    if not ForAll( G.relators, rel -> MappedWord( rel, G.generators, perms )
        = id ) then
        Error( "table columns do not satisfy the group relators" );
    fi;

end;


#############################################################################
##
#F  IsStandardized( <costab> ) . . . . .  test if coset table is standardized
##
IsStandardized := function ( table )

    local i, index, j, next, range;

    index := Length( table[1] );
    range := 2 * [ 1 .. Length( table ) / 2 ] - 1;
    j := 1;
    next := 2;
    while next < index do
        for i in range do
            if table[i][j] >= next then
                if table[i][j] > next then  return false;  fi;
                next := next + 1;
            fi;
        od;
        j := j + 1;
    od;
    return true;

end;


#############################################################################
##
#F  PresentationSubgroupRrs( <G>, <H> [,<string>] ) . . . . . . Tietze record
#F  PresentationSubgroupRrs( <G>, <costab> [,<string>] )  . .  for a subgroup
##
##  'PresentationSubgroupRrs'  uses the  Reduced Reidemeister-Schreier method
##  to compute a presentation  (i.e. a presentation record)  for a subgroup H
##  of a  finitely  presented  group  G.  The  generators  in  the  resulting
##  presentation   will be  named   <string>1,  <string>2, ... ,  the default
##  string is "_x".
##
##  Alternatively to a finitely presented group, the subgroup H  may be given
##  by its coset table.
##
PresentationSubgroupRrs := function ( arg )

    local aug, G, H, string, T, table, type;

    # check G to be a finitely presented group.
    G := arg[1];
    if not ( IsRec( G ) and IsBound( G.isFpGroup ) and G.isFpGroup ) then
        Error( "<group> must be a finitely presented group" );
    fi;

    # get the generator name.
    if Length( arg ) = 2 then
        string := "_x";
    else
        string := arg[3];
        if not IsString( string ) then
            Error( "third argument must be a string" );
        fi;
    fi;

    # check the second argument to be a subgroup or a coset table of G, and
    # get the coset table in either case.
    H := arg[2];
    if not ( IsRec( H ) and IsBound( H.isFpGroup ) and H.isFpGroup ) then
        # check the given table to be a legal coset table.
        table := H;
        CheckCosetTableFpGroup( G, table );
        # ensure that it is standardized.
        if not IsStandardized( table) then Print(
            "#I  Warning: the given coset table is not standardized,\n",
            "#I           a standardized copy will be used instead.\n" );
            table := Copy( table );
            StandardizeTable( table );
        fi;
    elif IsBound( H.parent ) and H.parent = G or not ( IsBound( H.parent ) )
        and H = G then
        # construct the coset table of H in G if it is not yet available.
        if not IsBound( H.cosetTable ) then
            H.cosetTable := CosetTableFpGroup( G, H );
            InfoFpGroup1( "#I  index is ", Length( H.cosetTable[1] ), "\n" );
        fi;
        table := H.cosetTable;
    else
        Error( "<group> is not the parent of <subgroup>" );
    fi;

    # apply the Reduced Reidemeister-Schreier method to construct an
    # augmented coset table of H.
    type := 2;
    aug := AugmentedCosetTableRrs( G, table, type, string );

    # determine a set of subgroup relators.
    RewriteSubgroupRelators( aug );

    # create a Tietze record for the resulting presentation.
    T := PresentationAugmentedCosetTable( aug );

    return T;
end;

PresentationSubgroup := PresentationSubgroupRrs;


#############################################################################
##
#F  PresentationNormalClosureRrs( <G>, <H> [,<string>] ) . . .  Tietze record
#F                                       for the normal closure of a subgroup
##
##  'PresentationNormalClosureRrs'  uses  the  Reduced  Reidemeister-Schreier
##  method  to compute a  presentation  (i.e. a presentation record)  for the
##  normal closure  N, say,  of a subgroup H of a finitely presented group G.
##  The  generators in the  resulting presentation  will be named  <string>1,
##  <string>2, ... , the default string is "_x".
##
PresentationNormalClosureRrs := function ( arg )

    local aug, cosTable, F, G, H, i, string, T, type;

    # check the first two arguments to be a finitely presented group and a
    # subgroup of that group.
    G := arg[1];
    if not ( IsRec( G ) and IsBound( G.isFpGroup ) and G.isFpGroup ) then
        Error( "<group> must be a finitely presented group" );
    fi;
    H := arg[2];
    if not ( IsRec( H ) and IsBound( H.isFpGroup ) and H.isFpGroup ) then
        Error( "<subgroup> must be a finitely presented group" );
    fi;
    if IsBound( H.parent ) and H.parent <> G or ( not IsBound( H.parent ) )
        and H <> G then
        Error( "<group> must be the parent of <subgroup>" );
    fi;

    # get the generator name.
    if Length( arg ) = 2 then
        string := "_x";
    else
        string := arg[3];
        if not IsString( string ) then
            Error( "third argument must be a string" );
        fi;
    fi;

    # construct a group record for the factor group F of G by the normal
    # closure N of H.
    F := Group( G.generators, IdWord);
    F.relators := Concatenation( G.relators, H.generators );

    # get the coset table of N in G by constructing the coset table of the
    # trivial subgroup in F.
    cosTable := CosetTableFpGroup( F, TrivialSubgroup( F ) );
    InfoFpGroup1( "#I  index is ", Length( cosTable[1] ), "\n" );

    # separate pairs of table columns which have been forced to be identical
    # by normal subgroup generators, but not by group relators.
    for i in [ 1 .. Length( G.generators ) ] do
        if IsIdentical( cosTable[2*i-1], cosTable[2*i] ) and
            not ( G.generators[i]^2 in G.relators or
            G.generators[i]^-2 in G.relators ) then
            cosTable[2*i] := Copy( cosTable[2*i-1] );
        fi;
    od;

    # apply the Reduced Reidemeister-Schreier method to construct a coset
    # table presentation of N.
    type := 2;
    aug := AugmentedCosetTableRrs( G, cosTable, type, string );

    # determine a set of subgroup relators.
    RewriteSubgroupRelators( aug );

    # create a Tietze record for the resulting presentation.
    T := PresentationAugmentedCosetTable( aug );

    return T;
end;

PresentationNormalClosure := PresentationNormalClosureRrs;


#############################################################################
##
#F  AugmentedCosetTableRrs( <group>, <coset table>, <type>, <string> )  . . .
#F                              do a RRS and return the augmented coset table
##
##  'AugmentedCosetTableRrs' applies the Reduced Reidemeister-Schreier method
##  to construct an  augmented coset table  for the  subgroup of  G  which is
##  defined by the  given coset table.  The new  subgroup generators  will be
##  named  <string>1, <string>2, ... .
##
AugmentedCosetTableRrs := function ( G, cosTable, type, string )

    local   index,                  # index of the group in the parent group
            negTable,               # coset table to be built up
            coFacTable,             # coset factor table
            numcols,                # number of columns in the tables
            numgens,                # number of generators
            span,                   # spanning tree
            ggens,                  # parent group gens prallel to columns
            gens,                   # new generators
            defs,                   # definitions of primary subgroup gens
            tree,                   # tree of generators
            tree1, tree2,           # components of tree of generators
            treelength,             # number of gens (primary + secondary)
            firstFree,  lastFree,   # first and last free coset
            firstCoinc, lastCoinc,  # first and last coincidence coset
            relators,               # rows for the relators
            rels,                   # representatives for the relators
            relsGen,                # relators beginning with a gen
            deductions,             # deduction queue
            ded,                    # index of current deduction in above
            nrdeds,                 # current number of deductions in above
            newgen,                 # new generator
            genname,                # name string
            i, ii, gen, inv,        # loop variables for generator
            g,                      # loop variable for generator col
            triple,                 # loop variable for relators as triples
            word, factors,          # words defining subgroup generators
            rep,                    # list of gens (representing a word)
            r, x, p, l,             # loop variables
            app,                    # application stack for 'ApplyRel'
            app2,                   # application stack for 'ApplyRel2'
            j, k,                   # loop variables
            fac,                    # tree entry
            count,                  # number of negative table entries
            next,                   #
            numoccs,                # number of gens which occur in the table
            occur,                  #
            treeNums,               #
            aug,                    # augmented coset table
            EnterDeduction,         # subroutine
            LoopOverAllCosets;      # subroutine


  EnterDeduction := function ( )

    # a deduction has been found, check the current coset table entry.
    # if triple[2][app[1]][app[2]] <> -app[4] or
    #     triple[2][app[3]][app[4]] <> -app[2] then
    #     Error( "unexpected coset table entry" );
    # fi;

    # compute the corresponding factors in "factors".
    app2[1] := triple[3];
    app2[2] := deductions[ded][2];
    app2[3] := -1;
    app2[4] := app2[2];
    ApplyRel2( app2, triple[2], triple[1] );
    factors := app2[7];

    # ensure that the scan provided a deduction.
    # if app2[1] - 1 <> app2[3]
    # or triple[2][app2[1]][app2[2]] <> - app2[4]
    # or triple[2][app2[3]][app2[4]] <> - app2[2]
    # then
    #     Error( "the given scan does not provide a deduction" );
    # fi;

    # extend the tree to define a proper factor, if necessary.
    fac := TreeEntry( tree, factors );

    # now enter the deduction to the tables.
    triple[2][app2[1]][app2[2]] := app2[4];
    coFacTable[triple[1][app2[1]]][app2[2]] := fac;
    triple[2][app2[3]][app2[4]] := app2[2];
    coFacTable[triple[1][app2[3]]][app2[4]] := - fac;
    nrdeds := nrdeds + 1;
    deductions[nrdeds] := [ triple[1][app2[1]], app2[2] ];
    treelength := tree[3];
    count := count - 2;
  end;


  LoopOverAllCosets := function ( )

    # loop over all the cosets
    for j in [1..index] do

        # run through all the rows and look for negative entries
        for i  in [ 1 .. numcols ]  do
            gen := negTable[i];

            if gen[j] < 0  then

                # add the current Schreier generator to the set of new
                # subgroup generators, and add the definition as deduction.
                k := - gen[j];
                word := ggens[i];
                while k > 1 do
                   word := word * ggens[span[2][k]]^-1;  k := span[1][k];
                od;
                k := j;
                while k > 1 do
                   word := ggens[span[2][k]] * word;  k := span[1][k];
                od;
                numgens := numgens + 1;
                genname := ConcatenationString( string,StringInt( numgens ));
                newgen := AbstractGenerator( genname );
                gens[numgens] := newgen;
                defs[numgens] := word;
                treelength := treelength + 1;
                tree[3] := treelength;
                tree[4] := numgens;
                if type = 0 then
                    tree1[treelength] := 0 * [ 1 .. numgens ];
                    tree1[treelength][numgens] := 1;
                    tree2[numgens] := 0;
                else
                    tree1[treelength] := 0;
                    tree2[treelength] := 0;
                fi;

                # add the definition as deduction.
                inv := negTable[i + 2*(i mod 2) - 1];
                k := - gen[j];
                gen[j] := k;
                coFacTable[i][j] := treelength;
                if inv[k] < 0 then
                    inv[k] := j;
                    ii := i + 2*(i mod 2) - 1;
                    coFacTable[ii][k] := - treelength;
                fi;
                count := count - 2;

                # set up the deduction queue and run over it until it's empty
                deductions[1] := [i,j];
                nrdeds := 1;
                ded := 1;
                while ded <= nrdeds  do

                    # apply all relators that start with this generator
                    for triple in relsGen[deductions[ded][1]] do
                        app[1] := triple[3];
                        app[2] := deductions[ded][2];
                        app[3] := -1;
                        app[4] := app[2];
                        if ApplyRel( app, triple[2] ) and
                            triple[2][app[1]][app[2]] < 0 and
                            triple[2][app[3]][app[4]] < 0 then
                            # a deduction has been found: compute the
                            # corresponding factor and enter the deduction to
                            # the tables and to the deductions lists.
                            EnterDeduction( );
                            if count <= 0 then
                                return;
                            fi;
                        fi;
                    od;

                    ded := ded + 1;
                od;

            fi;
        od;
    od;
  end;


    # check the type for being 0 or 2.
    if type <> 0 and type <> 2 then
        Error( "invalid type; it should be 0 or 2" );
    fi;

    # check the number of columns of the given coset table to be twice the
    # number of generators of the parent group G.
    numcols := Length( cosTable );
    if numcols <> 2 * Length( G.generators ) then
        Error( "parent group and coset table are inconsistent" );
    fi;
    index  := Length( cosTable[1] );

    # get a negative copy of the coset table, and initialize the coset factor
    # table (parallel to it) by zeros.
    negTable := [ ];
    coFacTable := [ ];
    for i in [1 .. numcols/2] do
        negTable[2*i-1] := - cosTable[2*i-1];
        coFacTable[2*i-1] := 0 * [ 1 .. index ];
        if IsIdentical( cosTable[2*i], cosTable[2*i-1] ) then
            negTable[2*i] := negTable[2*i-1];
            coFacTable[2*i] := coFacTable[2*i-1];
        else
            negTable[2*i] := - cosTable[2*i];
            coFacTable[2*i] := 0 * [ 1 .. index ];
        fi;
    od;
    count := index * ( numcols - 2 ) + 2;

    # construct the list relsGen which for each generator or inverse
    # generator contains a list of all cyclically reduced relators,
    # starting with that element, which can be obtained by conjugating or
    # inverting given relators. The relators in relsGen are represented as
    # lists of the coset table columns corresponding to the generators and,
    # in addition, as lists of the respective column numbers.
    rels := RelatorRepresentatives( G.relators );
    relsGen := RelsSortedByStartGen( G.generators, rels, negTable );
    SortRelsSortedByStartGen( relsGen );

    # check the number of columns to be twice the number of generators of
    # the parent group G.
    if numcols <> 2 * Length( G.generators ) then
        Error( "parent group and coset table are inconsistent" );
    fi;

    # initialize the tree of secondary generators.
    tree1 := 0 * [ 1 .. 100 ];
    if type = 0 then
        tree2 := [ ];
    else
        tree2 := 0 * [ 1 .. 100 ];
    fi;
    treelength := 0;
    tree := [ tree1, tree2, treelength, 0, type ];

    # initialize an empty deduction list
    deductions := 0 * [ 1 .. index ];
    nrdeds := 0;

    # get a spanning tree for the cosets
    span := SpanningTree( cosTable );

    # enter the coset definitions into the coset table.
    for k in [2..index] do

        j := span[1][k];
        i := span[2][k];
        ii := i + 2*(i mod 2) - 1;

        # check the current table entry.
        if negTable[i][j] <> - k or negTable[ii][k] <> -j then
            Error( "coset table and spanning tree are inconsistent" );
        fi;

        # enter the deduction.
        negTable[i][j] := k;
        if negTable[ii][k] < 0 then  negTable[ii][k] := j;  fi;
        nrdeds := nrdeds + 1;
        deductions[nrdeds] := [i,j];
    od;

    # make the local structures that are passed to 'ApplyRel' or, via
    # EnterDeduction, to 'ApplyRel2".
    app := 0 * [ 1 .. 4 ];
    app2 := 0 * [ 1 .. 9 ];
    if type = 0 then
        factors := tree2;
    else
        factors := [ ];
    fi;

    # set those arguments of ApplyRel2 which are global with respect to the
    # following loops.
    app2[5] := type;
    app2[6] := coFacTable;
    app2[7] := factors;
    if type = 0 then
        app2[8] := tree;
    fi;

    # set up the deduction queue and run over it until it's empty
    ded := 1;
    while ded <= nrdeds  do

        # apply all relators that start with this generator
        for triple in relsGen[deductions[ded][1]] do
            app[1] := triple[3];
            app[2] := deductions[ded][2];
            app[3] := -1;
            app[4] := app[2];
            if ApplyRel( app, triple[2] ) and triple[2][app[1]][app[2]] < 0
                and triple[2][app[3]][app[4]] < 0  then
                # a deduction has been found: compute the corresponding
                # factor and enter the deduction to the tables and to the
                # deductions lists.
                EnterDeduction( );
            fi;
        od;

        ded := ded + 1;
    od;

    # get a list of the parent group generators parallel to the table
    # columns.
    ggens := [ ];
    for i in [ 1 .. numcols/2 ] do
        ggens[2*i-1] := G.generators[i];
        ggens[2*i] := G.generators[i]^-1;
    od;

    # initialize the list of new subgroup generators
    numgens := 0;
    gens := [ ];
    defs := [ ];

    # loop over all the cosets
    LoopOverAllCosets( );

    # save the number of primary subgroup generators and the number of all
    # subgroup generators in the tree.
    tree[3] := treelength;

    # create the augmented coset table record.
    aug := rec( );
    aug.isAugmentedCosetTable := true;
    aug.type := type;
    aug.groupGenerators := G.generators;
    aug.groupRelators := G.relators;
    aug.cosetTable := cosTable;
    aug.cosetFactorTable := coFacTable;
    aug.primaryGeneratorWords := defs;
    aug.subgroupGenerators := gens;
    aug.tree := tree;

    # renumber the generators such that the primary ones precede the
    # secondary ones, and sort the tree and the factor table accordingly.
    if type = 2 then
        RenumberTree( aug );
    fi;

    # determine which generators occur in the augmented table.
    occur := 0 * [ 1 .. treelength ];
    for i in [ 1 .. numgens ] do
        occur[i] := 1;
    od;
    numcols := Length( coFacTable );
    numoccs := numgens;
    i := 1;
    while i < numcols do
        for next in coFacTable[i] do
            if next <> 0 then
                j := AbsInt( next );
                if occur[j] = 0 then
                    occur[j] := 1;  numoccs := numoccs + 1;
                fi;
            fi;
        od;
        i := i + 2;
    od;

    # build up a list of pointers from the occurring generators to the tree,
    # and define names for the occurring secondary generators.
    if numoccs > numgens then
        gens[numoccs] := 0;
    fi;
    treeNums := [ 1 .. numoccs ];
    i := numgens;
    for j in [ numgens+1 .. treelength ] do
        if occur[j] <> 0 then
            i := i + 1;
            genname := ConcatenationString( string, StringInt( i ) );
            newgen := AbstractGenerator( genname );
            gens[i] := newgen;
            treeNums[i] := j;
        fi;
    od;
    aug.treeNumbers := treeNums;

    # display a message
    InfoFpGroup1( "#I  RRS defined ", numgens, " primary and ",
        treelength - numgens, " secondary subgroup generators\n" );

    # return the augmented coset table.
    return aug;
end;


#############################################################################
##
#F  SpanningTree( <coset table> ) . . . . . . . . . . . . . . . spanning tree
##
##  'SpanningTree'  returns a spanning tree for the given coset table.
##
SpanningTree := function ( cosTable )

    local done, i, j, k, numcols, numrows, span1, span2;

    # check the given argument to be a coset table.
    if not ( IsList( cosTable ) and IsList( cosTable[1] ) ) then
        Error( "argument must be a coset table" );
    fi;
    numcols := Length( cosTable );
    numrows := Length( cosTable[1] );
    for i in [2 .. numcols] do
        if not ( IsList( cosTable[i] ) and
            Length( cosTable[i] ) = numrows ) then
            Error( "argument must be a coset table" );
        fi;
    od;

    # initialize the spanning tree.
    span1 := -1 * [1 .. numrows];
    span2 :=  0 * [1 .. numrows];
    span1[1] := 0;
    if numrows = 1 then  return [ span1, span2 ];  fi;

    # find the first occurrence in the table of each coset > 1.
    done := [1];
    for i in done do
        for j in [1 .. numcols] do
            k := cosTable[j][i];
            if span1[k] < 0 then
                span1[k] := i;  span2[k] := j;
                Add( done, k );
                if Length( done ) = numrows then
                    return [ span1, span2 ];
                fi;
            fi;
        od;
    od;

    # you should never come here, the argument is not a valid coset table.
    Error( "argument must be a coset table" );
end;


#############################################################################
##
#F  RenumberTree( <augmented coset table> ) . . . . .  renumber generators in
#F                                                      augmented coset table
##
##  'RenumberTree'  is  a  subroutine  of  the  Reduced Reidemeister-Schreier
##  routines.  It renumbers the generators  such that the primary genereators
##  precede the secondary ones.
##
RenumberTree := function ( aug )

    local coFacTable, column, convert, defs, i, index, j, k, null, numcols,
          numgens, tree, tree1, tree2, treelength, treesize;

    # get factor table, generators, and tree.
    coFacTable := aug.cosetFactorTable;
    defs := aug.primaryGeneratorWords;
    tree := aug.tree;

    #  truncate the tree, if necessary.
    treelength := tree[3];
    treesize := Length( tree[1] );
    if treelength < treesize then
        tree[1] := Sublist( tree[1], [ 1 .. treelength ] );
        tree[2] := Sublist( tree[2], [ 1 .. treelength ] );
    fi;

    # initialize some local variables.
    numcols := Length( coFacTable );
    index := Length( coFacTable[1] );
    numgens := Length( defs );

    # establish a local renumbering list.
    convert := 0 * [-treelength .. treelength];
    null := treelength + 1;
    j := treelength + 1;  k := numgens + 1;
    i := treelength;
    while i >= 1 do
        if tree[1][i] = 0 then
            k := k - 1;  convert[null+i] := k;  convert[null-i] := - k;
        else
            j := j - 1;  convert[null+i] := j;  convert[null-i] := - j;
            tree[1][j] := tree[1][i];  tree[2][j] := tree[2][i];
        fi;
        i := i - 1;
    od;

    if convert[null+numgens] <> numgens then

        # change the tree entries accordingly.
        for i in [1..numgens] do
            tree[1][i] := 0;  tree[2][i] := 0;
        od;
        tree1 := tree[1];  tree2 := tree[2];
        for j in [numgens+1..treelength] do
            tree1[j] := convert[null+tree1[j]];
            tree2[j] := convert[null+tree2[j]];
        od;

        # change the factor table entries accordingly.
        for i in [1..numcols] do
            if i mod 2 = 1 or
                not IsIdentical( coFacTable[i], coFacTable[i-1] ) then
                column := coFacTable[i];
                for j in [1..index] do
                    column[j] := convert[null+column[j]];
                od;
            fi;
        od;

    fi;
end;


#############################################################################
##
#F  RewriteSubgroupRelators( <aug> ) . . . . . rewrite subgroup relators from
#F                                                   an augmented coset table
##
##  'RewriteSubgroupRelators'  is a subroutine  of the  Reduced Reidemeister-
##  Schreier and the  Modified Todd-Coxeter  routines.  It computes  a set of
##  subgroup relators from the coset factor table of an augmented coset table
##  and the relators of the parent group.
##
RewriteSubgroupRelators := function ( aug )

    local app2, coFacTable, colRels, cols, cosTable, factor, ggens, grel, i,
          index, j, last, length, nums, numgens, p, rel, rels, type;

    # check the type.
    type := aug.type;
    if type <> 2 then  Error( "invalid type; it should be 2" );  fi;

    # initialize some local variables.
    ggens := aug.groupGenerators;
    cosTable := aug.cosetTable;
    coFacTable := aug.cosetFactorTable;
    index := Length( cosTable[1] );
    rels := [ ];

    # initialize the structure that is passed to 'ApplyRel2'
    app2 := 0 * [ 1 .. 9 ];
    app2[5] := type;
    app2[6] := coFacTable;
    app2[7] := 0 * [ 1 .. 100 ];

    # loop over all group relators
    for grel in aug.groupRelators do

        # get two copies of the group relator, one as a list of words in the
        # factor table columns and one as a list of words in the coset table
        # columns.
        length := LengthWord( grel );
        nums := 0 * [ 1 .. length ];
        cols := 0 * [ 1 .. length ];
        for i in [ 1 .. length ]  do
            factor := Subword( grel, i, i );
            if factor in ggens then
                p := 2 * Position( ggens, factor );
                nums[2*i]   := p-1;
                nums[2*i-1] := p;
                cols[2*i]   := cosTable[p-1];
                cols[2*i-1] := cosTable[p];
            else
                p := 2 * Position( ggens, factor^-1 );
                nums[2*i]   := p;
                nums[2*i-1] := p-1;
                cols[2*i]   := cosTable[p];
                cols[2*i-1] := cosTable[p-1];
            fi;
        od;

        # loop over all cosets and determine the subgroup relators which are
        # induced by the current group relator.
        for i in [ 1 .. index ] do

            # scan the ith coset through the current group relator and
            # collect the factors in rel.
            app2[1] := 2;
            app2[2] := i;
            app2[3] := 2 * length - 1;
            app2[4] := i;
            ApplyRel2( app2, cols, nums );

            # add the resulting subgroup relator to rels.
            rel := app2[7];
            last := Length( rel );
            if last > 0 then
                MakeCanonical( rel );
                if Length( rel ) > 0 and not rel in rels then
                    AddSet( rels, CopyRel( rel ) );
                fi;
            fi;
        od;
    od;

    # loop over all subgroup generators.
    numgens := Length( aug.primaryGeneratorWords );
    for j in [ 1 .. numgens ] do

        # get two copies of the subgroup generator, one as a list of words in
        # the factor table columns and one as a list of words in the coset
        # table columns.
        grel := aug.primaryGeneratorWords[j];
        length := LengthWord( grel );
        nums := 0 * [ 1 .. length ];
        cols := 0 * [ 1 .. length ];
        for i in [ 1 .. length ]  do
            factor := Subword( grel, i, i );
            if factor in ggens then
                p := 2 * Position( ggens, factor );
                nums[2*i]   := p-1;
                nums[2*i-1] := p;
                cols[2*i]   := cosTable[p-1];
                cols[2*i-1] := cosTable[p];
            else
                p := 2 * Position( ggens, factor^-1 );
                nums[2*i]   := p;
                nums[2*i-1] := p-1;
                cols[2*i]   := cosTable[p];
                cols[2*i-1] := cosTable[p-1];
            fi;
        od;

        # scan coset 1 through the current subgroup generator and collect the
        # factors in rel.
        app2[1] := 2;
        app2[2] := 1;
        app2[3] := 2 * length - 1;
        app2[4] := 1;
        ApplyRel2( app2, cols, nums );

        # add as last factor the generator number j.
        rel := app2[7];
        last := Length( rel );
        if last > 0 and rel[last] = - j then
            last := last - 1;
            rel := Sublist( rel, [1 .. last] );
        else
            last := last + 1;
            rel[last] := j;
        fi;
        # add the resulting subgroup relator to rels.
        if last > 0 then
            MakeCanonical( rel );
            if Length( rel ) > 0 and not rel in rels then
                AddSet( rels, CopyRel( rel ) );
            fi;
        fi;
    od;

    aug.subgroupRelators := rels;
end;


#############################################################################
##
#F  PresentationAugmentedCosetTable( <aug>  [,<print level>] ) . . . create a
#F                                                              Tietze record
##
##  'PresentationAugmentedCosetTable'  creates a presentation,  i.e. a Tietze
##  record, from the given augmented coset table.
##
PresentationAugmentedCosetTable := function ( arg )

    local aug, coFacTable, comps, convert, gens, i, invs, lengths, numgens,
          numrels, pointers, printlevel, rel, rels, T, tietze, total, tree,
          treelength, treeNums;

    # check the first argument to be an augmented coset table.
    aug := arg[1];
    if not ( IsRec( aug ) and IsBound( aug.isAugmentedCosetTable ) and
        aug.isAugmentedCosetTable ) then
        Error( "first argument must be an augmented coset table" );
    fi;

    # check the second argument to be an integer.
    printlevel := 1;
    if Length( arg ) = 2 then  printlevel := arg[2];  fi;
    if not IsInt( printlevel ) then
        Error (" second argument must be an integer" );
    fi;

    # initialize some local variables.
    rels := Copy( aug.subgroupRelators );
    gens := Copy( aug.subgroupGenerators );
    coFacTable := aug.cosetFactorTable;
    tree := ShallowCopy( aug.tree );
    treeNums := Copy( aug.treeNumbers );
    treelength := Length( tree[1] );

    # create the Tietze record.
    T := rec( );
    T.isTietze := true;
    T.operations := PresentationOps;

    # construct the relator lengths list.
    numrels := Length( rels );
    lengths := 0 * [ 1 .. numrels ];
    total := 0;
    for i in [ 1 .. numrels ] do
        lengths[i] := Length( rels[i] );
        total := total + lengths[i];
    od;

    # initialize the Tietze stack.
    tietze := 0 * [ 1 .. TZ_LENGTHTIETZE ];
    tietze[TZ_NUMRELS] := numrels;
    tietze[TZ_RELATORS] := rels;
    tietze[TZ_LENGTHS] := lengths;
    tietze[TZ_FLAGS] := 1 + 0 * [ 1 .. numrels ];
    tietze[TZ_TOTAL] := total;

    # renumber the generators in the relators, if necessary.
    numgens := Length( gens );
    if numgens < treelength then
        convert := 0 * [ 1 .. treelength ];
        for i in [ 1 .. numgens ] do
            convert[treeNums[i]] := i;
        od;
        for rel in rels do
            for i in [ 1 .. Length( rel ) ] do
                if rel[i] > 0 then
                    rel[i] := convert[rel[i]];
                else
                    rel[i] := - convert[-rel[i]];
                fi;
            od;
        od;
    fi;

    # construct the generators and the inverses list, and save the generators
    # as components of the Tietze record.
    invs := 0 * [ 1 .. 2 * numgens + 1 ];
    comps := 0 * [ 1 .. numgens ];
    pointers := [ 1 .. treelength ];
    for i in [ 1 .. numgens ] do
        invs[numgens+1-i] := i;
        invs[numgens+1+i] := - i;
        T.(String( i )) := gens[i];
        comps[i] := i;
        pointers[treeNums[i]] := treelength + i;
    od;

    # define the remaining Tietze stack entries.
    tietze[TZ_NUMGENS] := numgens;
    tietze[TZ_GENERATORS] := gens;
    tietze[TZ_INVERSES] := invs;
    tietze[TZ_NUMREDUNDS] := 0;
    tietze[TZ_STATUS] := [ 0, 0, -1 ];
    tietze[TZ_MODIFIED] := false;

    # define some Tietze record components.
    T.generators := tietze[TZ_GENERATORS];
    T.tietze := tietze;
    T.components := comps;
    T.nextFree := numgens + 1;
    T.identity := IdWord;

    # initialize the Tietze options by their default values.
    T.eliminationsLimit := 100;
    T.expandLimit := 150;
    T.generatorsLimit := 0;
    T.lengthLimit := "infinity";
    T.loopLimit := "infinity";
    T.printLevel := 0;
    T.saveLimit := 10;
    T.searchSimultaneous := 20;

    # save the tree as component of the Tietze record.
    tree[TR_TREENUMS] := treeNums;
    tree[TR_TREEPOINTERS] := pointers;
    tree[TR_TREELAST] := treelength;
    T.tree := tree;

    # save the definitions of the primary generators as words in the original
    # group generators.
    T.primaryGeneratorWords := aug.primaryGeneratorWords;

    # handle relators of length 1 or 2.
    TzHandleLength1Or2Relators( T );

    # sort the relators.
    TzSort( T );
    T.printLevel := printlevel;

    # return the Tietze record.
    return T;
end;


#############################################################################
##
#F  AbelianInvariantsSubgroupFpGroupMtc( <G>, <H> ) . . . . . . . . . . . . .
#F  . . . . . abelian invariants of the normal closure of the subgroup H of G
##
##  'AbelianInvariantsSubgroupFpGroupMtc'   uses  the  Modified  Todd-Coxeter
##  method  to compute the  abelian invariants of a  subgroup H of a finitely
##  presented group G.
##
AbelianInvariantsSubgroupFpGroupMtc := function ( G, H )
    return AbelianInvariantsOfList(
                ElementaryDivisorsMat(
                    RelatorMatrixAbelianizedSubgroupMtc( G, H ) ) );
end;


#############################################################################
##
#F  RelatorMatrixAbelianizedSubgroupMtc( <G>, <H> [,<string>] ) . . . . . . .
#F  . . . . . . . . . . . . . . .  relator matrix for an abelianized subgroup
##
##  'RelatorMatrixAbelianizedSubgroupMtc'   uses  the  Modified  Todd-Coxeter
##  coset representative enumeration method  to compute  a matrix of abelian-
##  ized defining relators for a subgroup H of a finitely presented group  G.
##
RelatorMatrixAbelianizedSubgroupMtc := function ( arg )

    local aug, G, H, i, string, T, type;

    # check the first two arguments to be a finitely presented group and a
    # subgroup of that group.
    G := arg[1];
    if not ( IsRec( G ) and IsBound( G.isFpGroup ) and G.isFpGroup ) then
        Error( "<group> must be a finitely presented group" );
    fi;
    H := arg[2];
    if not ( IsRec( H ) and IsBound( H.isFpGroup ) and H.isFpGroup ) then
        Error( "<subgroup> must be a finitely presented group" );
    fi;
    if IsBound( H.parent ) and H.parent <> G or ( not IsBound( H.parent ) )
        and H <> G then
        Error( "<group> must be the parent of <subgroup>" );
    fi;

    # get the generator name string.
    if Length( arg ) = 2 then
        string := "_x";
    else
        string := arg[3];
        if not IsString( string ) then
            Error( "third argument must be a string" );
        fi;
    fi;

    # do a Modified Todd-Coxeter coset representative enumeration to
    # construct an augmented coset table of H.
    type := 0;
    aug := AugmentedCosetTableMtc( G, H, type, string );

    # determine a set of abelianized subgroup relators.
    RewriteAbelianizedSubgroupRelators( aug );

    return aug.subgroupRelators;

end;


#############################################################################
##
#F  AbelianInvariantsSubgroupFpGroupRrs( <G>, <H> ) . . . . . . . . . . . . .
#F  AbelianInvariantsSubgroupFpGroupRrs( <G>, <costab> ) . . .  . . . . . . .
#F  . . . . . abelian invariants of the normal closure of the subgroup H of G
##
##  'AbelianInvariantsSubgroupFpGroupRrs'   uses  the  Reduced  Reidemeister-
##  Schreier method  to compute the  abelian invariants  of a subgroup H of a
##  finitely presented group G.
##
##  Alternatively to a finitely presented group, the subgroup H  may be given
##  by its coset table.
##
AbelianInvariantsSubgroupFpGroupRrs := function ( G, H )
    return AbelianInvariantsOfList(
                ElementaryDivisorsMat(
                    RelatorMatrixAbelianizedSubgroupRrs( G, H ) ) );
end;

AbelianInvariantsSubgroupFpGroup := AbelianInvariantsSubgroupFpGroupRrs;


#############################################################################
##
#F  RelatorMatrixAbelianizedSubgroupRrs( <G>, <H> [,<string>] ) . . . . . . .
#F  RelatorMatrixAbelianizedSubgroupRrs( <G>, <costab> [,<string>] )  . . . .
#F  . . . . . . . . . . . . . . .  relator matrix for an abelianized subgroup
##
##  'RelatorMatrixAbelianizedSubgroupRrs'   uses  the   Reduced Reidemeister-
##  Schreier method  to compute a matrix of abelianized defining relators for
##  a subgroup H of a finitely presented group G.
##
##  Alternatively to a finitely presented group, the subgroup H  may be given
##  by its coset table.
##
RelatorMatrixAbelianizedSubgroupRrs := function ( arg )

    local aug, G, H, string, T, table, type;

    # check G to be a finitely presented group.
    G := arg[1];
    if not ( IsRec( G ) and IsBound( G.isFpGroup ) and G.isFpGroup ) then
        Error( "<group> must be a finitely presented group" );
    fi;

    # get the generator name.
    if Length( arg ) = 2 then
        string := "_x";
    else
        string := arg[3];
        if not IsString( string ) then
            Error( "third argument must be a string" );
        fi;
    fi;

    # check the second argument to be a subgroup or a coset table of G, and
    # get the coset table in either case.
    H := arg[2];
    if not ( IsRec( H ) and IsBound( H.isFpGroup ) and H.isFpGroup ) then
        # check the given table to be a legal coset table.
        table := H;
        CheckCosetTableFpGroup( G, table );
        # ensure that it is standardized.
        if not IsStandardized( table) then Print(
            "#I  Warning: the given coset table is not standardized,\n",
            "#I           a standardized copy will be used instead.\n" );
            table := Copy( table );
            StandardizeTable( table );
        fi;
    elif IsBound( H.parent ) and H.parent = G or not ( IsBound( H.parent ) )
        and H = G then
        # construct the coset table of H in G if it is not yet available.
        if not IsBound( H.cosetTable ) then
            H.cosetTable := CosetTableFpGroup( G, H );
            InfoFpGroup1( "#I  index is ", Length( H.cosetTable[1] ), "\n" );
        fi;
        table := H.cosetTable;
    else
        Error( "<group> is not the parent of <subgroup>" );
    fi;

    # apply the Reduced Reidemeister-Schreier method to construct an
    # augmented coset table of H.
    type := 0;
    aug := AugmentedCosetTableRrs( G, table, type, string );

    # determine a set of abelianized subgroup relators.
    RewriteAbelianizedSubgroupRelators( aug );

    return aug.subgroupRelators;

end;

RelatorMatrixAbelianizedSubgroup := RelatorMatrixAbelianizedSubgroupRrs;


#############################################################################
##
#F  AbelianInvariantsNormalClosureFpGroupRrs( <G>, <H> )  . . . . . . . . . .
#F  . . . . . abelian invariants of the normal closure of the subgroup H of G
##
##  'AbelianInvariantsNormalClosureFpGroupRrs' uses the Reduced Reidemeister-
##  Schreier method  to compute the abelian invariants  of the normal closure
##  of a subgroup H of a finitely presented group G.
##
AbelianInvariantsNormalClosureFpGroupRrs := function ( G, H )
    return AbelianInvariantsOfList(
                ElementaryDivisorsMat(
                    RelatorMatrixAbelianizedNormalClosureRrs( G, H ) ) );
end;

AbelianInvariantsNormalClosureFpGroup :=
    AbelianInvariantsNormalClosureFpGroupRrs;


#############################################################################
##
#F  RelatorMatrixAbelianizedNormalClosureRrs( <G>, <H> [,<string>] )  . . . .
#F  . . . . . relator matrix for the abelianized normal closure of a subgroup
##
##  'RelatorMatrixAbelianizedNormalClosureRrs' uses the Reduced Reidemeister-
##  Schreier method  to compute a matrix of abelianized defining relators for
##  the  normal  closure of a subgroup  H  of a  finitely presented  group G.
##
RelatorMatrixAbelianizedNormalClosureRrs := function ( arg )

    local aug, cosTable, F, G, H, i, string, T, type;

    # check the first two arguments to be a finitely presented group and a
    # subgroup of that group.
    G := arg[1];
    if not ( IsRec( G ) and IsBound( G.isFpGroup ) and G.isFpGroup ) then
        Error( "<group> must be a finitely presented group" );
    fi;
    H := arg[2];
    if not ( IsRec( H ) and IsBound( H.isFpGroup ) and H.isFpGroup ) then
        Error( "<subgroup> must be a finitely presented group" );
    fi;
    if IsBound( H.parent ) and H.parent <> G or ( not IsBound( H.parent ) )
        and H <> G then
        Error( "<group> must be the parent of <subgroup>" );
    fi;

    # get the generator name.
    if Length( arg ) = 2 then
        string := "_x";
    else
        string := arg[3];
        if not IsString( string ) then
            Error( "third argument must be a string" );
        fi;
    fi;

    # construct a group record for the factor group F of G by the normal
    # closure N of H.
    F := Group( G.generators, IdWord);
    F.relators := Concatenation( G.relators, H.generators );

    # get the coset table of N in G by constructing the coset table of the
    # trivial subgroup in F.
    cosTable := CosetTableFpGroup( F, TrivialSubgroup( F ) );
    InfoFpGroup1( "#I  index is ", Length( cosTable[1] ), "\n" );

    # separate pairs of table columns which have been forced to be identical
    # by normal subgroup generators, but not by group relators.
    for i in [ 1 .. Length( G.generators ) ] do
        if IsIdentical( cosTable[2*i-1], cosTable[2*i] ) and
            not ( G.generators[i]^2 in G.relators or
            G.generators[i]^-2 in G.relators ) then
            cosTable[2*i] := Copy( cosTable[2*i-1] );
        fi;
    od;

    # apply the Reduced Reidemeister-Schreier method to construct a coset
    # table presentation of N.
    type := 0;
    aug := AugmentedCosetTableRrs( G, cosTable, type, string );

    # determine a set of abelianized subgroup relators.
    RewriteAbelianizedSubgroupRelators( aug );

    return aug.subgroupRelators;

end;

RelatorMatrixAbelianizedNormalClosure :=
    RelatorMatrixAbelianizedNormalClosureRrs;


#############################################################################
##
#F  RewriteAbelianizedSubgroupRelators( <aug> ) . . . . . rewrite abelianized
#F  . . . . . . . . . . . . . subgroup relators from an augmented coset table
##
##  'RewriteAbelianizedSubgroupRelators'  is  a  subroutine  of  the  Reduced
##  Reidemeister-Schreier and the Modified Todd-Coxeter routines. It computes
##  a set of
##  subgroup relators from the coset factor table of an augmented coset table
##  and the relators of the parent group.
##
RewriteAbelianizedSubgroupRelators := function ( aug )

    local app2, coFacTable, colRels, cols, cosTable, factor, ggens, grel, i,
          index, j, length, nums, numgens, numrels, p, rels, total, tree,
          treelength, type;

    # check the type for being zero.
    type := aug.type;
    if type <> 0 then
        Error( "type of augmented coset table is not zero" );
    fi;

    # initialize some local variables.
    ggens := aug.groupGenerators;
    cosTable := aug.cosetTable;
    coFacTable := aug.cosetFactorTable;
    index := Length( cosTable[1] );
    tree := aug.tree;
    treelength := tree[3];
    numgens := tree[4];
    total := numgens;
    rels := 0 * [ 1 .. total ];
    for i in [ 1 .. total ] do
        rels[i] := 0 * [ 1 .. numgens ];
    od;
    numrels := 0;

    # display some information.
    InfoFpGroup2( "#I  index is ", index, "\n" );
    InfoFpGroup2( "#I  number of generators is ", numgens, "\n" );
    InfoFpGroup2( "#I  tree length is ", treelength, "\n" );

    # initialize the structure that is passed to 'ApplyRel2'
    app2 := 0 * [ 1 .. 9 ];
    app2[5] := type;
    app2[6] := coFacTable;
    app2[8] := tree;

    # loop over all group relators
    for grel in aug.groupRelators do

        # get two copies of the group relator, one as a list of words in the
        # factor table columns and one as a list of words in the coset table
        # columns.
        length := LengthWord( grel );
        nums := 0 * [ 1 .. length ];
        cols := 0 * [ 1 .. length ];
        for i in [ 1 .. length ]  do
            factor := Subword( grel, i, i );
            if factor in ggens then
                p := 2 * Position( ggens, factor );
                nums[2*i]   := p-1;
                nums[2*i-1] := p;
                cols[2*i]   := cosTable[p-1];
                cols[2*i-1] := cosTable[p];
            else
                p := 2 * Position( ggens, factor^-1 );
                nums[2*i]   := p;
                nums[2*i-1] := p-1;
                cols[2*i]   := cosTable[p];
                cols[2*i-1] := cosTable[p-1];
            fi;
        od;

        # loop over all cosets and determine the subgroup relators which are
        # induced by the current group relator.
        for i in [ 1 .. index ] do

            # scan the ith coset through the current group relator and
            # collect the factors in rel.
            numrels := numrels + 1;
            if numrels > total then
                total := total + 1;
                rels[total] := 0 * [ 1 .. numgens ];
            fi;
            app2[7] := rels[numrels];
            app2[1] := 2;
            app2[2] := i;
            app2[3] := 2 * length - 1;
            app2[4] := i;
            ApplyRel2( app2, cols, nums );

            # add the resulting subgroup relator to rels.
            numrels := AddAbelianRelator( rels, numrels );
        od;
    od;

    # loop over all subgroup generators.
    for j in [ 1 .. numgens ] do

        # get two copies of the subgroup generator, one as a list of words in
        # the factor table columns and one as a list of words in the coset
        # table columns.
        grel := aug.primaryGeneratorWords[j];
        length := LengthWord( grel );
        nums := 0 * [ 1 .. length ];
        cols := 0 * [ 1 .. length ];
        for i in [ 1 .. length ]  do
            factor := Subword( grel, i, i );
            if factor in ggens then
                p := 2 * Position( ggens, factor );
                nums[2*i]   := p-1;
                nums[2*i-1] := p;
                cols[2*i]   := cosTable[p-1];
                cols[2*i-1] := cosTable[p];
            else
                p := 2 * Position( ggens, factor^-1 );
                nums[2*i]   := p;
                nums[2*i-1] := p-1;
                cols[2*i]   := cosTable[p];
                cols[2*i-1] := cosTable[p-1];
            fi;
        od;

        # scan coset 1 through the current subgroup generator and collect the
        # factors in rel.
        numrels := numrels + 1;
        if numrels > total then
            total := total + 1;
            rels[total] := 0 * [ 1 .. numgens ];
        fi;
        app2[7] := rels[numrels];
        app2[1] := 2;
        app2[2] := 1;
        app2[3] := 2 * length - 1;
        app2[4] := 1;
        ApplyRel2( app2, cols, nums );

        # add as last factor the generator number j.
        rels[numrels][j] := rels[numrels][j] + 1;

        # add the resulting subgroup relator to rels.
        numrels := AddAbelianRelator( rels, numrels );
    od;

    # reduce the relator list to its proper size.
    if numrels < numgens then
        for i in [ numrels + 1 .. numgens ] do
            rels[i] := 0 * [ 1 .. numgens ];
        od;
        numrels := numgens;
    fi;
    for i in [ numrels + 1 .. total ] do
        Unbind( rels[i] );
    od;

    aug.subgroupRelators := rels;
end;


#############################################################################
##
#F  CanonicalRelator( <relator> )  . . . . . . . . . . . .  canonical relator
##
##  'CanonicalRelator'  returns the  canonical  representative  of the  given
##  relator.
##
CanonicalRelator := function ( Rel )

    local i, i1, ii, j, j1, jj, k, k1, kk, length, max, min, rel;

    rel := Rel;
    length := Length( rel );
    max := Maximum( rel );
    min := Minimum( rel );

    if max < - min then
        i := 0;
    else
        i := Position( rel, max, 0 );
        k := i;
        while k <> false do
            k := Position( rel, max, k );
            if k <> false then
                ii := i;  kk := k;  k1 := k - 1;
                while kk <> k1 do
                    if ii = length then ii := 1;  else  ii := ii + 1;  fi;
                    if kk = length then kk := 1;  else  kk := kk + 1;  fi;
                    if rel[kk] > rel[ii] then  i := k;  kk := k1;
                    elif rel[kk] < rel[ii] then  kk := k1;
                    elif kk = k1 then  k := false;  fi;
                od;
            fi;
        od;
    fi;

    if - min < max then
        j := 0;
    else
        j := Position( rel, min, 0 );
        k := j;
        while k <> false do
            k := Position( rel, min, k );
            if k <> false then
                jj := j;  kk := k;  j1 := j + 1;
                while jj <> j1 do
                    if jj = 1 then jj := length;  else  jj := jj - 1;  fi;
                    if kk = 1 then kk := length;  else  kk := kk - 1;  fi;
                    if rel[kk] < rel[jj] then  j := k;  jj := j1;
                    elif rel[kk] > rel[jj] then  jj := j1;
                    elif jj = j1 then  k := false;  fi;
                od;
            fi;
        od;
    fi;

    if - min = max then
        if i = 1 then i1 := length;  else  i1 := i - 1;  fi;
        ii := i;  jj := j;
        while ii <> i1 do
            if ii = length then ii := 1;  else  ii := ii + 1;  fi;
            if jj = 1 then jj := length;  else  jj := jj - 1;  fi;
            if - rel[jj] < rel[ii] then  j := 0;  ii := i1;
            elif - rel[jj] > rel[ii] then  i := 0;  ii := i1;  fi;
        od;
    fi;

    if i = 0 then  rel := - Reversed( rel );  i := length + 1 - j;  fi;
    if i > 1 then  rel := Concatenation(
        Sublist( rel, [i..length] ), Sublist( rel, [1..i-1] ) );
    fi;

    return( rel );
end;


#############################################################################
##
#F  ReducedRrsWord( <word> ) . . . . . . . . . . . . . . freely reduce a word
##
##  'ReducedRrsWord' freely reduces the given RRS word and returns the result.
##
ReducedRrsWord := function ( word )

    local i, j, reduced;

    # initialize the result.
    reduced := [];

    # run through the factors of the given word and cancel or add them.
    j := 0;
    for i in [ 1 .. Length( word ) ] do
        if word[i] <> 0 then
            if j > 0 and word[i] = - reduced[j] then  j := j-1;
            else  j := j+1;  reduced[j] := word[i];  fi;
        fi;
    od;

    if j < Length( reduced ) then
        reduced := Sublist( reduced, [1..j] );
    fi;

    return( reduced );
end;



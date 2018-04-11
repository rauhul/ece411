#############################################################################
##
#A  ctpermch.g                  GAP library                     Thomas Breuer
#A                                                           & Goetz Pfeiffer
##
#A  @(#)$Id: ctpermch.g,v 3.24.1.3 1996/08/19 07:33:28 sam Exp $
##
#Y  Copyright 1990-1992,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
##  This file contains those  functions  that are needed to compute and test
##  possible permutation characters.
##
#N  TODO:
#N  - 'IsPermChar( <tbl>, <pc> )'
#N  - 'Constituent' und 'Maxdeg' - Optionen in 'PermComb'
##
#H  $Log: ctpermch.g,v $
#H  Revision 3.24.1.3  1996/08/19 07:33:28  sam
#H  fixed sideeffect of 'PermComb' because of sorting characters
#H
#H  Revision 3.24.1.2  1994/11/14 16:29:39  sam
#H  fixed a bug in error message,
#H  changed ATLAS component in case of high multiplicities
#H
#H  Revision 3.24.1.1  1994/10/13  13:42:26  sam
#H  changed ATLAS component in PermCharInfo
#H
#H  Revision 3.24  1993/10/19  16:48:22  sam
#H  fixed possible absence of 'powermap' component
#H
#H  Revision 3.22  1993/05/10  12:51:14  sam
#H  fixed two bugs concerning trivial character expected to be first one
#H
#H  Revision 3.21  1992/11/16  16:35:40  sam
#H  generalized 'PermCharInfo' for list of characters
#H
#H  Revision 3.20  1992/10/08  10:10:47  sam
#H  added 'ATLAS' component in 'PermCharInfo'
#H
#H  Revision 3.19  1992/07/03  10:13:14  sam
#H  added 'PermCharInfo'
#H
#H  Revision 3.18  1992/04/03  17:45:36  martin
#H  changed the author line
#H
#H  Revision 3.17  1992/03/13  18:16:51  goetz
#H  changed structure of 'PermChars'.
#H
#H  Revision 3.16  1991/12/20  10:15:42  sam
#H  renamed 'Kernel' to 'KernelChar'
#H
#H  Revision 3.15  1991/12/09  14:49:48  goetz
#H  changed some 'GcdInt's to 'Gcd'.
#H
#H  Revision 3.14  1991/12/04  13:42:44  sam
#H  indented these damned functions !
#H
#H  Revision 3.13  1991/12/04  13:02:15  sam
#H  indented ':=' in function definition
#H
#H  Revision 3.12  1991/11/08  17:48:18  sam
#H  correction in 'Info' lines
#H
#H  Revision 3.11  1991/10/01  14:28:06  casper
#H  changed 'Gcd' to 'GcdInt
#H
#H  Revision 3.10  1991/10/01  13:46:22  casper
#H  changed 'E(3)' to '"infinity"'
#H
#H  Revision 3.9  1991/10/01  09:18:20  sam
#H  changed 'VERBOSE' to 'InfoCharTable2'
#H
#H  Revision 3.8  1991/09/30  14:03:04  sam
#H  changed 'Gcd' to 'GcdInt'
#H
#H  Revision 3.7  1991/09/26  07:31:46  sam
#H  bug in 'PermCandidates' fixed
#H
#H  Revision 3.6  1991/09/06  07:29:47  sam
#H  changed 'LcmList' to 'Lcm'
#H
#H  Revision 3.5  1991/09/05  15:49:09  sam
#H  changed 'Transposed' to 'TransposedMat'
#H
#H  Revision 3.4  1991/09/05  15:39:50  sam
#H  changed 'GcdList' to 'Gcd'
#H
#H  Revision 3.3  1991/09/05  15:28:59  sam
#H  changed 'RankMatrix' to 'RankMat'
#H
#H  Revision 3.2  1991/09/05  14:52:04  sam
#H  changed 'Quo' to 'QuoInt'
#H
#H  Revision 3.1  1991/09/03  13:22:22  goetz
#H  changed 'reps' to 'orders'.
#H
#H  Revision 3.0  1991/09/03  13:15:27  goetz
#H  Initial Revision.
#H
##


#############################################################################
##
#F  InfoCharTable1( ... ) . . . info function for the character table package
#F  InfoCharTable2( ... ) . . . info function for the character table package
##
    if not IsBound( InfoCharTable1 )  then InfoCharTable1 := Ignore;  fi;
    if not IsBound( InfoCharTable2 )  then InfoCharTable2 := Ignore;  fi;


#############################################################################
##
#F  SubClass( <tbl>, <char> ) . . . . . . . . . . . size of class in subgroup
##
##  Given a permutation character <char> of the group with character table
##  <tbl> 'SubClass' determines the sizes of the intersections of the
##  classes with the corresponding subgroup. Of course this has to be a
##  positive integer.
##
SubClass  := function(tbl, char)

   local sc, i;

   sc:= [1];

   for i in [2..Length(char)] do
      sc[i]:= (char[i] * tbl.classes[i]) / char[1];
      if not IsInt(sc[i]) then
        Print( "#E SubClass(): noninteger number of elements in class ",
               i, "\n");
      fi;
   od;

   return(sc);

end;


#############################################################################
##
#F  TestPerm1( <tbl>, <char> ) . . . . . . . . . . . . . . . . test permchar
##
##  performs CAS test 1 and 2 for permutation characters
##
TestPerm1 := function(tbl, char)
   
   local i, pm;

   # TEST 1:
   for i in char do
      if i < 0 then
        return(1);
      fi;
   od;

   # TEST 2:
   if IsBound( tbl.powermap ) then
     for pm in tbl.powermap do
        for i in [2..Length(char)] do
          if char[i] > char[pm[i]] then return(2); fi;
        od;
     od;
   fi;

   return(0);

end;


#############################################################################
##
#F  TestPerm2( <tbl>, <char> ) . . . . . . . . . . . . test permchar
##
##  performs CAS test 3, 4, and 5 for permutation characters
##
TestPerm2 := function(tbl, char)

   local i, j, nccl, subord, subclass, subfak, prime, sum;

   subord:= tbl.order / char[1];
   if not IsInt(subord) then
      InfoCharTable2("-\c");
      return(1);
   fi;
   nccl:= Length(char);

   # TEST 3:
   for i in [2..nccl] do
      if char[i] <> 0 and subord mod tbl.orders[i] <> 0 then
        InfoCharTable2("=\c");
        return(3);
      fi;
   od;

   # TEST 4:
   subclass:= [1];
   for i in [2..nccl] do
      subclass[i]:= (char[i] * tbl.classes[i]) / char[1];
      if not IsInt(subclass[i]) then
        InfoCharTable2("#\c");
        return(4);
      fi;
   od;

   # TEST 5:
   subfak:= Set(Factors(subord));
   for prime in subfak do
      if subord mod prime^2 <> 0 then
        sum:= 0;
        for j in [2..nccl] do
          if tbl.orders[j] = prime then
            sum:= sum + subclass[j];
          fi;
        od;
        if (sum - prime + 1) mod (prime * (prime - 1)) <> 0 then
          InfoCharTable2(":\c");
          return(5);
        fi;
        if subord mod (sum / (prime - 1)) <> 0 then
          InfoCharTable2(";\c");
          return(5);
        fi;
      fi;
   od;

   return(0);

end;


#############################################################################
##
#F  TestPerm3( <tbl>, <permch> ) . . . . . . . . . . . . . . . test permchar
##
##  'TestPerm3' performs CAS test 6
##
TestPerm3 := function(tbl, permch)

   local i, j, nccl, fb, sc, corbs, lc, phii, pc;

   fb:= [];
   lc:= [];
   phii:= [];
   nccl:= Length(tbl.orders);

   for i in [1..nccl] do
      if not IsBound(lc[i]) then
        corbs:= ClassOrbitCharTable(tbl, i);
        lc[i]:= Length(corbs);
        for j in corbs do
          lc[j]:= lc[i];
        od;
        phii[i]:= Phi(tbl.orders[i]) / lc[i];
      fi;
   od;

   for pc in permch do
      sc:= SubClass(tbl, pc);
      for j in [2..nccl] do
        if tbl.orders[j] > 2 and IsBound(phii[j]) then
          if sc[j] mod phii[j] <> 0 then
            AddSet(fb, pc);
          fi;
        fi;
      od;
   od;

   return(fb);

end;


#############################################################################
##
#F  Inequalities( <tbl>, <chars> [, <option>] ) . . .
#F                                            projected system of inequalites
##
##  There are two ways to organize the projection. The first is the straight
##  approach which takes the rationalized characters in their original order
##  and by this guarantees the character with the smallest degree to be
##  considered first. --> no option
##  The other way tries to keep the number of intermediate inequalities
##  small by eventually changing the order of characters. -->option "small"
##
Inequalities := function( arg )

   local tbl, chars, option, 
         i, j, h, o, dim, nccl, ncha, c, X, dir, root, ineq, tuete, 
         Conditor, Kombinat, other, mini, con, conO, conU,
         proform, project;

   # scan arg
   if   Length( arg ) = 2 and IsCharTable( arg[1] ) then
      tbl:= arg[1];
      chars:= arg[2];
      option:= "";
   elif Length( arg ) = 3 and IsCharTable( arg[1] ) then
      tbl:= arg[1];
      chars:= arg[2];
      option:= arg[3];
   fi;

   # local functions
   proform:= function(tuete, s, dir)
      local i, lo, lu, conO, conU, komO, komU, res;

      conO:= []; conU:= [];
      res:= 0;
      for i in [1..Length(tuete)] do
        if tuete[i][dir] < 0 then
          Add(conO, Kombinat[i]);
        elif tuete[i][dir] > 0 then
          Add(conU, Kombinat[i]);
        else
          res:= res + 1;
        fi;
      od;

      lo:= Length(conO); lu:= Length(conU);

      if s = dim+1 then
        return(res + lo * lu);
      fi;

      for komO in conO do
        if Length(komO) = 1 then
          res:= res + lu;
        else
          for komU in conU do
            if Length(Union(komO, komU)) <= dim+3 - s then
              res:= res + 1;
            fi;
          od;
        fi;
      od;

      return(res);
   end;

   project:= function(tuete, dir)
      local i, j, k, l, C, sum, com, lo, lu, conO, conU, 
            lineO, lineU, lc, kombi, res;

      InfoCharTable2("project(", dir, ")");

      conO:= []; conU:= [];
      res:= []; kombi:= [];
      for i in [1..Length(tuete)] do
        if tuete[i][dir] < 0 then
          Add(conO, rec(con:= tuete[i], kom:= Kombinat[i]));
          Add(Conditor[dir], tuete[i]);
        elif tuete[i][dir] > 0 then
          Add(conU, rec(con:= tuete[i], kom:= Kombinat[i]));
          Add(Conditor[dir], tuete[i]);
        else
          Add(res, tuete[i]); Add(kombi, Kombinat[i]);
        fi;
      od;

      lo:= Length(conO); lu:= Length(conU);

      InfoCharTable2(lo, " ", lu,"\n");

      for lineO in conO do
        for lineU in conU do
          com:= Union(lineO.kom, lineU.kom);
          lc:= Length(com);
          if lc <= dim+3 - dir then
            sum:= lineU.con[dir] * lineO.con - lineO.con[dir] * lineU.con;
            sum:= Gcd(sum)^-1 * sum;
            if lc - Length(lineO.kom) = 1 or lc - Length(lineU.kom) = 1 then
              Add(res, sum); Add(kombi, com);
            else
              C:= List(Sublist(ineq, com), x-> Sublist(x, [dir..dim+1]));
              if RankMat(C) = lc-1 then
                Add(res, sum); Add(kombi, com);
              fi;
            fi;
          fi;
        od;
      od;
      Kombinat:= kombi;
      return(res);
   end;

   nccl:= Length(tbl.classes);
   X:= RationalizedMat( chars );

   c:= TransposedMat(X);

   # determine power conditions
   # ie: for each class find a root and replace coloumn by difference.

   root:= ClassRootsCharTable(tbl);
   ineq:= [];
   other:= [];
   for i in [2..nccl] do
      if root[i] = [] then
        AddSet(ineq, c[i]);
        AddSet(other, c[i]);
      else
        AddSet(ineq, c[i] - c[root[i][1]]);
        for j in root[i] do
          AddSet(other, c[i] - c[j]);
        od;
      fi;
   od;
   ineq:= List(ineq, x->Gcd(x)^-1*x);
   other:= List(other, x->Gcd(x)^-1*x);

   ncha:= Length(X);

   dim:= Length(ineq);
   if dim <> Length(ineq[1])-1 then
      Error("nonregular problem");
   fi;

   Conditor:= List([1..dim+1], x->[]);
   Kombinat:= List([1..dim+1], x->[x]);
   tuete:= ineq;
   
   for i in Reversed([2..dim+1]) do
      dir:= 0;

      if option = "small" then

         # find optimal direction
         for j in [2..i] do
           o:= proform(tuete, i, j);
           if dir = 0 or o <= mini then
             mini:= o; dir:= j;
           fi;
         od;

         # make it the current one
         if dir <> i then
           for j in [i..ncha] do
             for con in Conditor[j] do
               h:= con[dir]; con[dir]:= con[i]; con[i]:= h;
             od;
           od;
           for con in tuete do
             h:= con[dir]; con[dir]:= con[i]; con[i]:= h;
           od;
           for con in other do
             h:= con[dir]; con[dir]:= con[i]; con[i]:= h;
           od;

           h:= X[dir]; X[dir]:= X[i]; X[i]:= h;
         fi;
      fi;

      # perform projection
      tuete:= project(tuete, i);

      # if regular, reinstall reference
      if Length(tuete) = i-2 then
         ineq:= tuete;
         dim:= i-2;
         Kombinat:= List([1..i-1], x->[x]);
         InfoCharTable2("REGULAR !!!\n");
      fi;

   od;

   # don't use too many inequalities
   for i in [2..ncha] do
    if Length(Conditor[i]) > 1 then
      conO:= Filtered(Conditor[i], x->x[i] < 0);
      conU:= Filtered(Conditor[i], x->x[i] > 0);
      if Length(conO) > i then
        conO:= Sublist(conO, [1..i]);
      fi;
      if Length(conU) > i then
        conU:= Sublist(conU, [1..i]);
      fi;
      Conditor[i]:= Union(conO, conU);
    fi;
   od;

   # but don't forget original conditions
   for con in other do
      i:= ncha;
      while con[i] = 0 do i:= i-1; od;
      AddSet(Conditor[i], con);
   od;

   return(rec(obj:= X, Conditor:= Conditor));

end;


#############################################################################
##
#F  Permut( <tbl>, <arec> )               2 Jul 91
##
##  determine possible permutation characters
##
Permut := function(tbl, arec)

   local permel, sortedchars, degree,
         a, amin, amax, c, ncha, len, i, j, k, l, permch, 
         Conditor, comb, cond, X, divs, pm, minR, maxR,
         d, sub, del, s, nccl, root, other, 
         time1, time2, total, free, const, lowerBound, upperBound,
         einfug, solveKnot, nextLevel, insertValue, suche;

   if Length( tbl.irreducibles ) <> Length( tbl.centralizers ) then

      Error( "<tbl> must be complete character table" );

   fi;
      
   if IsBound(arec.ineq) then

     permel:= arec.ineq;

   else 

     sortedchars:= ShallowCopy( tbl.irreducibles );
     SortCharactersCharTable( tbl, sortedchars, "degree" );
     permel:= Inequalities( tbl, sortedchars );

   fi;

   if IsBound(arec.degree) then
      degree:= arec.degree;
   else
      degree:= 0;
   fi;

   # local functions
   lowerBound:= function(cond, const, free, s)
      local j, unten;

      unten:= -const;
      for j in [2..s-1] do
        if free[j] then
          if cond[j] < 0 then
            unten:= unten - amin[j]*cond[j];
          elif cond[j] > 0 then
            unten:= unten - amax[j]*cond[j];
          fi;
        fi;
      od; 
      if unten <= 0 then return(0);
      else return(QuoInt(unten-1, cond[s])+1);
      fi;
   end;

   upperBound:= function(cond, const, free, s)
      local j, oben;
      oben:= const;
      for j in [2..s-1] do if free[j] then
          if cond[j] < 0 then
            oben:= oben + amin[j]*cond[j];
          elif cond[j] > 0 then
            oben:= oben + amax[j]*cond[j];
          fi;
      fi;od; 
      if oben < 0 then return(-1);
      else return(QuoInt(oben, -cond[s]));
      fi;
   end;

   nextLevel:= function(const, free)
      local h, i, j, p, c, con, cond, unten, oben, maxu, mino,
            unique, first, mindeg, maxdeg;

      unique:= [];
      for h in [2..ncha] do 
        cond:= Conditor[h];
        c:= const[h];
       if free[h] then
         # compute amin, amax
         if not IsBound(first) then
           first:= h;
         fi;
         maxu:= 0;
         mino:= tbl.order;
         for i in [1..Length(cond)] do
           if cond[i][h] > 0 then
             maxu:= Maximum(maxu, lowerBound(cond[i], const[h][i], free, h));
           else
             mino:= Minimum(mino, upperBound(cond[i], const[h][i], free, h));
           fi;
         od;

         amin[h]:= maxu;
         amax[h]:= mino;
         if mino < maxu then
           return(h);
         fi;

         if mino = maxu then AddSet(unique, h); fi;
       else

         if IsBound(first) then
         # interpret inequalities for lower steps !
           for i in [1..Length(cond)] do
             con:= cond[i];
             s:= h-1;
             while s > 1  and (not free[s] or con[s] = 0) do
               s:= s-1;
             od;
             if s > 1 then
               if con[s] > 0 then
                 unten:= lowerBound(con, c[i], free, s);
                 amin[s]:= Maximum(amin[s], unten);
               else
                 oben:= upperBound(con, c[i], free, s);
                 amax[s]:= Minimum(amax[s], oben);
               fi;
               if amin[s] > amax[s] then return(s);
               elif amin[s] = amax[s] then AddSet(unique, s);
               fi;
             fi;
           od;

         fi;
       fi;
      od;

      maxdeg:= 1;
      mindeg:= 1;
      for i in [2..ncha] do 
         maxdeg:= maxdeg + amax[i] * X[i][1];
         mindeg:= mindeg + amin[i] * X[i][1];
      od;
      if minR > maxdeg or maxR < mindeg then
        return(0);
      fi;

      if unique <> [] then return(unique);
      else return(first); fi;

   end;

   insertValue:= function(const, s)
      local i, j, c;

      const:= Copy(const);

      for i in [s..ncha] do
         c:= const[i];
         for j in [1..Length(c)] do
           c[j]:= c[j] + a[s]*Conditor[i][j][s];
         od;
      od;

      return(const);
   end;

   solveKnot:= function(const, free)
      local i, p, s, char, fail;

      free:= Copy(free);
      if Set(free) = [false] then
        total:= total+1;
        char:= X[1];
        for j in [2..ncha] do
          char:= char + a[j] * X[j];
        od;
        fail:= TestPerm2(tbl, char);
        if fail = 0 then
          Add(permch, char);
          InfoCharTable2("\n", Length(permch), a, "\n", char, "\n");
        fi;
      else
        s:= nextLevel(const, free);
        if IsList(s) then
          for i in s do
            free[i]:= false;
            a[i]:= amin[i];
            const:= insertValue(const, i);
          od;
          solveKnot(const, free);
          elif s > 0 then
            for i in [amin[s]..amax[s]] do
              a[s]:= i;
              amin[s]:= i;
              amax[s]:= i;
              free[s]:= false;
              solveKnot(insertValue(const, s), free);
            od;
          fi;
      fi;
   end;

   suche:= function(s)
      local unten, oben, i, j, char, fail,
            maxu, mino, c;

      unten:= [];
      oben:= [];

      maxu:= 0;

      for i in [1..Length(Conditor[s].u)] do
        unten:= 0;
        for j in [1..s-1] do
          unten:= unten - a[j]*Conditor[s].u[i][j];
        od;
        if unten <= 0 then
          unten:= 0;
        else
          unten:= QuoInt(unten-1, Conditor[s].u[i][s]) + 1;
        fi;
 
        maxu:= Maximum(maxu, unten);
      od;
      for i in [1..Length(Conditor[s].o)] do
        oben:= 0;
        for j in [1..s-1] do
          oben:= oben + a[j]*Conditor[s].o[i][j];
        od;
        if oben < 0 then
          oben:= -1;
        else
          oben:= QuoInt(oben, -Conditor[s].o[i][s]);
        fi;
        if not IsBound(mino) then
          mino:= oben;
        else
          mino:= Minimum(mino, oben);
        fi;
      od;

      for i in [maxu..mino] do
        a[s]:= i;
        if s < ncha then 
          suche(s+1);
        else
          total:= total+1;
          char:= a * X;
          fail:= TestPerm2(tbl, char);
          if fail = 0 then
            Add(permch, char);
            InfoCharTable2("\n", Length(permch), a, "\n", char, "\n");
          fi;
        fi;
      od;
      a[s]:= 0;
   end;

   nccl:= Length(tbl.classes);
   total:= 0;
   X:= permel.obj;
   permch:= [];

   ncha:= Length(X);

   a:= [1];

   if IsBound(arec.degree) then
      minR:= Minimum(arec.degree); maxR:= Maximum(arec.degree);
      amax:= [1]; amin:= [1];
      Conditor:= permel.Conditor;
      free:= List(Conditor, x->true);
      free[1]:= false;
      const:= List(Conditor, x-> List(x, y->y[1]));
      solveKnot(const, free);
   else
      Conditor:= [];
      for i in [1..ncha] do
        Conditor[i]:= rec(o:= Filtered(permel.Conditor[i], x->x[i] < 0),
                          u:= Filtered(permel.Conditor[i], x->x[i] > 0));
      od;
      suche(2);
   fi;

   InfoCharTable2("\nTotal number of tested Characters:", total);
   InfoCharTable2("\nSurviving:      ", Length(permch), "\n");

   return(Set(permch));

end;


#############################################################################
##
#F  PermBounds( <tbl> , <option> ) . . . . . . .  boundary points for simplex 
##
PermBounds := function(tbl, degree)

   local i, j, h, o, dim, nccl, ncha, c, X, dir, root, ineq, other, rho,
         vec, deglist, point;

   nccl:= Length(tbl.classes);
   X:= RationalizedMat(tbl.irreducibles);

   c:= TransposedMat(X);

   # determine power conditions
   # i.e.: for each class find a root and replace column by difference.

   root:= ClassRootsCharTable(tbl);
   ineq:= [];
   other:= [];
   for i in [2..nccl] do
      if root[i] = [] then
        AddSet(ineq, c[i]);
        AddSet(other, c[i]);
      else
        AddSet(ineq, c[i] - c[root[i][1]]);
        for j in root[i] do
          AddSet(other, c[i] - c[j]);
        od;
      fi;
   od;
   ineq:= List(ineq, x->Gcd(x)^-1*x);
   other:= List(other, x->Gcd(x)^-1*x);

   ncha:= Length(X);

   dim:= Length(ineq);
   if dim <> Length(ineq[1])-1 then
      Error("nonregular problem");
   fi;

   # now correct inequalities ?
   vec:= List(ineq, x->-x[1]);
   ineq:= List(ineq, x->Sublist(x,[2..dim+1]));

   # determine boundary points
   deglist:= List(Sublist(X, [2..ncha]), x->x[1]);
   Add(ineq, deglist);
   Add(vec, degree-1);

   point:= TransposedMat(ineq);
   Add(point, -vec);

   point:= point^-1;

   dim:= Length(point[1]);

   rho:= point[dim][dim]^-1 * Sublist(point[dim], [1..dim-1]);
   point:= Sublist(List(point, x-> x[dim]^-1 * Sublist(x, [1..dim-1])),
                    [1..dim-1]);

   return(rec(obj:= X, point:= point, rho:= rho, other:= other));

end;


#############################################################################
##
#F  PermComb( <tbl>, <arec> ) . . . . . . . . . . . .  permutation characters
##
PermComb := function(tbl, arec)

   local mindeg, maxdeg, lincom, prep, xdegrees, X, total,
       point, rho, permch, Constituent, maxList, minList;

   # For some strange reason, the trivial character is expected to be the
   # first one.  So sort the irreducibles, if necessary.
   if not ForAll( tbl.irreducibles[1], x -> x = 1 ) then

     tbl:= ShallowCopy( tbl );
     tbl.irreducibles:= ShallowCopy( tbl.irreducibles );
     SortCharactersCharTable( tbl, "degree" );
     # (will be wrong if 'arec' contains component 'bounds' ...)

   fi;

   maxList:= function(list)
      local i, col, max;
      max:= [];
      for i in [1..Length(list[1])] do
         col:= Maximum(List(list, x->x[i]));
         Add(max, Int(col));
      od;
      return max;
   end;
   
   minList:= function(list)
      local i, col, min;
      min:= [];
      for i in [1..Length(list[1])] do
         col:= Minimum(List(list, x->x[i]));
         if col <= 0 then
            Add(min, 0);
         elif IsInt(col) then
            Add(min, col);
         else
            Add(min, Int(col)+1);
         fi;
      od;
      return min;
   end;

   lincom:= function()

      local i, j, k, a, d, ncha, comb, mdeg, maxb, searching, char, fail;

      ncha:= Length(xdegrees);
      mdeg:= List([1..ncha], x->0);
      comb:= List([1..ncha], x->0);
      maxb:= [];
      for i in [1..ncha-1] do
         maxb[i]:= 0;
         for j in [2..i] do
           maxb[i]:= maxb[i] + xdegrees[j] * maxdeg[j];
         od;
      od;
      d:= arec.degree - Constituent[1];
      k:= ncha - 1;
      searching:= true;
   
      while searching do
         for j in Reversed([1..k]) do
           a:= d - mdeg[j+1] - maxb[j];
           if a <= 0 then
             comb[j+1]:= 0;
           else
             comb[j+1]:= Minimum(QuoInt(a-1, xdegrees[j+1])+1, maxdeg[j+1]);
           fi;
           mdeg[j]:= mdeg[j+1] + comb[j+1] * xdegrees[j+1];
         od;

         if mdeg[1] = d then
           total:= total+1;
           char:= Constituent + comb * X;
           fail:= TestPerm1(tbl, char);
           if fail = 0 then
             fail:= TestPerm2(tbl, char);
           fi;
           if fail = 0 then
             AddSet(permch, char);
             InfoCharTable2("\n", Length(permch), comb, "\n", char, "\n");
           else
               InfoCharTable2("-\c");
           fi;
         fi;
   
         i:= 3;
         while i <= ncha and
           (comb[i] >= maxdeg[i] or mdeg[i-1]+ xdegrees[i] > d) do
           i:= i+1;
         od;
         if i <= ncha then
            mdeg[i-1]:= mdeg[i-1] + xdegrees[i];
            comb[i]:= comb[i] + 1;
            k:= i-2;
         else
           searching:= false;
         fi;
      od;
      return();
   end;

   total:= 0;
   if IsBound(arec.bounds) then
      prep:= arec.bounds;
   else
      prep:= PermBounds(tbl, 0);
   fi;

   if prep = false then
      X:= RationalizedMat(tbl.irreducibles);
   else
      X:= prep.obj;
      rho:= tbl.order^-1 * (List(prep.point, x->prep.rho) - prep.point);
   fi;
   xdegrees:= List(X, x->x[1]);
   mindeg:= List(X, x-> 0);
   mindeg[1]:= 1;
   permch:= [];

   if IsRec(prep) then
      point:= prep.point + arec.degree * rho;
      maxdeg:= [1];
      Append(maxdeg, maxList(point));
      mindeg:= [1];
      Append(mindeg, minList(point));
   else
      maxdeg:= xdegrees;
   fi;
   # mindeg schreibt constituenten vor:
   Constituent:= mindeg * X;
   maxdeg:= maxdeg - mindeg;

   lincom();

   return permch;

end;


#############################################################################
##
#F  PermCandidates( <tbl>, <characters>, <torso> )
##
##  computes all permutation character candidates of the character table
##  <tbl> which have only the (necessarily rational) characters <characters>
##  as constituents and which are completions of <torso>: Known values of the
##  candidates must be nonnegative integers in <torso>, the other positions
##  of <torso> are unbound; at least the degree '<torso>[1]' must be an
##  integer.
##
PermCandidates := function( tbl, characters, torso )
    local i, chi, matrix, fusion, moduls, divs, normindex, candidate,
          classes, nonzerocol, possibilities, rest, images, uniques,
          nccl, min_anzahl, min_class, erase_uniques, impossible, 
          evaluate, ischaracter, first, localstep,
          remain, ncha, pos, fusionperm, newimages, oldrows, newmatrix,
          step, erster, descendclass, j, row, isnozerorow;

    ischaracter:= function( genchar )   # we know that 'genchar' is a
                                        # generalized character
    local i, chi, classes, cand;
    classes:= tbl.classes;
    cand:= [];
    for i in [ 1 .. Length( genchar ) ] do
      cand[i]:= genchar[i] * classes[i];
    od;
    for chi in characters do
      if cand * chi < 0 then return false; fi;
    od;
    return true;
    end;
    #
    isnozerorow:= function( row )
    local i;
    for i in row do if i <> 0 then return true; fi; od;
    return false;
    end;
    
    # step 1: check and improve input
    
    if not IsInt( torso[1] ) or torso[1] <= 0 then     # degree
      Error( "degree must be positive integer" );
    elif tbl.order mod torso[1] <> 0 then
      return [];
    fi;
    for i in [ 1 .. Length( characters[1] ) ] do       # necessary zeroes
      if ( tbl.order / torso[1] ) mod tbl.orders[i] <> 0 then
        if IsBound( torso[i] ) and IsInt( torso[i] ) and torso[i] <> 0 then
          Error( "value must be zero at class ", i );
        fi;
        torso[i]:= 0;
      fi;
    od;
    matrix:= [];                                        # delete impossibles
    for chi in characters do
      if chi[1] < torso[1] then AddSet( matrix, chi ); fi;
    od;
    if matrix = [] then       # At most the trivial character is possible
      if ForAll( torso, x -> x = 1 ) then
        return [ List( [ 1 .. Length( tbl.centralizers ) ], x -> 1 ) ];
      fi;
    fi;
    matrix:= CollapsedMat( matrix, [ ] );
    fusion:= matrix.fusion;
    matrix:= matrix.mat;
    moduls:= [];
    for i in [ 1 .. Length( fusion ) ] do
      if IsBound( moduls[ fusion[i] ] ) then
        moduls[ fusion[i] ]:= Maximum( moduls[ fusion[i] ],
                                       tbl.centralizers[i] );
        # Would Lcm be allowed?
      else
        moduls[ fusion[i] ]:= tbl.centralizers[i];
      fi;
    od;
    divs:= [ torso[1] ];    # X[1] / Gcd( X[1], classes[g] ) | X[g]
                            # better: X[1] / Gcd( X[1], order/N(g) ) | X[g]
    for i in [ 2 .. Length( fusion ) ] do
      normindex:= ( tbl.classes[i] * Length( ClassOrbitCharTable( tbl, i ) ) )
                                                         / Phi( tbl.orders[i] );
      if IsBound( divs[ fusion[i] ] ) then
        divs[ fusion[i] ]:= Lcm( divs[ fusion[i] ],
                                 torso[1] / GcdInt( torso[1], normindex ) );
      else
        divs[ fusion[i] ]:= torso[1] / GcdInt( torso[1], normindex );
      fi;
    od;
    candidate:= [];
    nonzerocol:= [];
    classes:= [];
    for i in [ 1 .. Length( moduls ) ] do
      candidate[i]:= 0;
      nonzerocol[i]:= true;
      classes[i]:= 0;
    od;
    for i in [ 1 .. Length( fusion ) ] do
      classes[ fusion[i] ]:= classes[ fusion[i] ] + tbl.classes[i];
    od;
    possibilities:= []; # global list of all permutation character candidates
    rest:= tbl.order;
    images:= [];
    uniques:= [];
    for i in [ 1 .. Length( fusion ) ] do
      if IsBound( torso[i] ) and IsInt( torso[i] ) then
        if IsBound( images[ fusion[i] ] ) then
          if torso[i] <> images[ fusion[i] ] then
            return [];      # different values in equal columns
          fi;
        else
          images[ fusion[i] ]:= torso[i];
          AddSet( uniques, fusion[i] );
          rest:= rest - classes[ fusion[i] ] * torso[i];
          if rest < 0 then return []; fi;
        fi;
      fi;
    od;
    nccl:= Length( moduls );
    
    InfoCharTable2( "#I PermCandidates : input checked\n" );
    
    # step 2: first elimination before backtrack:
    
    erase_uniques:= function( uniques, nonzerocol, candidate, rest )
    
    # eliminate all unique columns, adapt nonzerocol;
    # then look if other columns become unique or if a contradiction occurs;
    # also look at which column the least number of values is left
    
    local i, j, extracted, col, row, quot, val, ggt, a, b, k, u, anzahl,
          firstallowed, step, gencharacter, shrink;

    extracted:= [];
    while uniques <> [] do
      for col in uniques do
        if col < 0 then         # nonzero entries in 'col' already eliminated
          col:= -col;
          candidate[ col ]:= ( candidate[ col ] + images[ col ] )
                             mod moduls[ col ];
          row:= false;
        else                    # eliminate nonzero entries in 'col'
          candidate[ col ]:= ( candidate[ col ] + images[ col ] )
                             mod moduls[ col ];
          row:= StepModGauss( matrix, moduls, nonzerocol, col );
    
          # delete zero rows:
          shrink:= [];
          for i in matrix do if isnozerorow( i ) then Add( shrink, i ); fi; od;
          matrix:= shrink;
        fi;
        if row <> false then
          Add( extracted, row );
          quot:= candidate[ col ] / row[ col ];
          if not IsInt( quot ) then
            impossible:= true;
            return extracted;
          fi;
          for j in [ 1 .. nccl ] do
            if nonzerocol[j] then
              candidate[j]:= ( candidate[j] - quot * row[j] ) mod moduls[j];
            fi;
          od;
        elif candidate[col] <> 0 then
          impossible:= true;
          return extracted;
        fi;
        nonzerocol[col]:= false;
      od;
      min_anzahl:= "infinity";
      uniques:= [];
    
      # compute the number of possible values 'x' for each class 'i'\:
      # 'x' must be smaller or equal 'Minimum( rest / classes[i], torso[1] )',
      #             divisible by 'divs[i]' and
      #             congruent '-candidate[i]' modulo the Gcd of column 'i'.
      for i in [ 1 .. nccl ] do
        if nonzerocol[i] then
          val:= moduls[i];
          for j in matrix do val:= GcdInt( val, j[i]); od;  # the Gcd of 'i'
          # zerocol iff val = moduls[i]
          first:= ( - candidate[i] ) mod val;  # the first possible value
                                                    # in the case 'divs[i] = 1'
          if divs[i] = 1 then
            localstep:= val;          # all values are
                                      # 'first, first + val, first + 2*val ..'
          else
            ggt:= Gcdex( divs[i], val );
            a:= ggt.coeff1;
            ggt:= ggt.gcd;
            if first mod ggt <> 0 then   # ggt divides 'divs[i]' and hence 'x';
                                         # since ggt divides 'val', which must
                                         # divide '( x + candidate[i] )',
                                         # we must have ggt dividing 'first'
              impossible:= true;
              return extracted;
            fi;
            localstep:= Lcm( divs[i], val );
            first:= ( first * a * divs[i] / ggt ) mod localstep;
                                         # satisfies the required congruences
                                         # (and that is enough here)
          fi;
          anzahl:= Int( ( Minimum( Int( rest[1] / classes[i] ), torso[1] )
                          - first + localstep ) / localstep );
          if anzahl <= 0 then       # contradiction
            impossible:= true;
            return extracted;
          elif anzahl = 1 then      # unique
            images[i]:= first;
            if val = moduls[i] then     # no elimination necessary
                                        # (the column consists of zeroes)
              Add( uniques, -i );
            else
              Add( uniques, i );
            fi;
            rest[1]:= rest[1] - classes[i] * images[i];
          elif anzahl < min_anzahl then
            min_anzahl:= anzahl;
            step:= localstep;
            firstallowed:= first;
            min_class:= i;
          fi;
        fi;
      od;
    od;
    if min_anzahl = "infinity" then
      if rest[1] = 0 then
        gencharacter:= Indirected( images, fusion );
        if ischaracter( gencharacter ) and TestPerm1( tbl, gencharacter ) = 0
           and TestPerm2( tbl, gencharacter ) = 0 then
          Add( possibilities, gencharacter );
        fi;
      fi;
      impossible:= true;
    else
      images[ min_class ]:= rec( firstallowed:= firstallowed, # first value
                                 step:= step,                 # step
                                 anzahl:= min_anzahl );       # no. of values
      impossible:= false;
    fi;
    return extracted;
    # impossible = true: calling function will return from backtrack
    # impossible = false: then min_class < E( 3 ), and images[ min_class ]
    #           contains the informations for descending at min_class
    end;
    
    rest:= [ rest ];
    erase_uniques( uniques, nonzerocol, candidate, rest );
    
    # here we may forget the extracted rows, later in the backtrack they must be
    # appended after each return.
    
    rest:= rest[1];
    if impossible then return possibilities; fi;
    
    InfoCharTable2( "#I PermCandidates : unique columns erased, there are ",
                    Length( Filtered( nonzerocol, x -> x ) ), " columns left,\n",
                    "#I    the number of constituents is ",
                    Length( matrix ), ".\n" );
    
    # step 3: collapse
    
    remain:= Filtered( [ 1 .. nccl ], x -> nonzerocol[x] );
    for i in [ 1 .. Length( matrix ) ] do
      matrix[i]:= Sublist( matrix[i], remain );
    od;
    candidate:=  Sublist( candidate, remain );
    divs:=       Sublist( divs, remain );
    nonzerocol:= Sublist( nonzerocol, remain );
    moduls:=     Sublist( moduls, remain );
    classes:=    Sublist( classes, remain );
    matrix:= ModGauss( matrix, moduls );
    ncha:= Length( matrix );
    pos:= 1;
    fusionperm:= [];
    newimages:= [];
    for i in remain do
      fusionperm[ i ]:= pos;
      if IsBound( images[i] ) then newimages[ pos ]:= images[i]; fi;
      pos:= pos + 1;
    od;
    min_class:= fusionperm[ min_class ];
    for i in Difference( [ 1 .. nccl ], remain ) do
      fusionperm[i]:= pos;
      newimages[ pos ]:= images[i];
      pos:= pos + 1;
    od;  
    images:= newimages;
    fusion:= CompositionMaps( fusionperm, fusion );
    nccl:= Length( nonzerocol );
    
    InfoCharTable2( "#I PermCandidates : known columns physically deleted,\n",
                    "#I    a backtrack search will be needed\n" );
    
    # step 4: backtrack
    
    evaluate:= function( candidate, rest, nonzerocol, uniques )
    local i, j, col, val, row, quot, extracted, step, erster, descendclass;
    rest:= [ rest ];
    extracted:= erase_uniques( [ uniques ], nonzerocol, candidate, rest );
    rest:= rest[1];
    if impossible then return extracted; fi;
    descendclass:= min_class;
    step:= images[ descendclass ].step;    # spalten-ggt
    erster:= images[ descendclass ].firstallowed;
    rest:= rest + ( step - erster ) * classes[ descendclass ];
    for i in [ 1 .. min_anzahl ] do
      images[ descendclass ]:= erster + (i-1) * step;
      rest:= rest - step * classes[ descendclass ];
      oldrows:=
              evaluate( Copy( candidate ), rest, Copy( nonzerocol ), descendclass );
      Append( matrix, oldrows );
      if Length( matrix ) > ( 3 * ncha ) / 2 then
        newmatrix:= [];         # matrix:= ModGauss( matrix, moduls );
        for j in [ 1 .. Length( matrix[1] ) ] do
          if nonzerocol[j] then
            row:= StepModGauss( matrix, moduls, nonzerocol, j );
            if row <> false then Add( newmatrix, row ); fi;
          fi;
        od;
        matrix:= newmatrix;
      fi;
    od;
    return extracted;
    end;
    
    #
    
    step:= images[min_class].step;      # spalten-ggt
    erster:= images[min_class].firstallowed;
    descendclass:= min_class;
    rest:= rest + ( step - erster ) * classes[ descendclass ];
    for i in [ 1 .. min_anzahl ] do
      images[ descendclass ]:= erster + (i-1) * step;
      rest:= rest - step * classes[ descendclass ];
      oldrows:=
            evaluate( Copy( candidate ), rest, Copy( nonzerocol ), descendclass );
      Append( matrix, oldrows );
      if Length( matrix ) > ( 3 * ncha ) / 2 then
        newmatrix:= [];          # matrix:= ModGauss( matrix, moduls );
        for j in [ 1 .. Length( matrix[1] ) ] do
          if nonzerocol[j] then
            row:= StepModGauss( matrix, moduls, nonzerocol, j );
            if row <> false then Add( newmatrix, row ); fi;
          fi;
        od;
        matrix:= newmatrix;
      fi;
    od;
    return possibilities;
    end;


#############################################################################
##
#F  'PermCandidatesFaithful( <tbl>, <chars>, <norm\_subgrp>, <nonfaithful>,
#F                           <lower>, <upper>, <torso> )'
##
##  computes all permutation character candidates of the character table
##  <tbl> which have only the (necessarily rational) characters <chars>
##  as constituents and which are completions of <torso>: Known values of the
##  candidates must be nonnegative integers in <torso>, the other positions
##  of <torso> are unbound; at least the degree '<torso>[1]' must be an
##  integer.
##

# 'PermCandidatesFaithful'\\
# '      ( tbl, chars, norm\_subgrp, nonfaithful, lower, upper, torso )'
# 
# reference of variables\:
# \begin{itemize}
# \item 'tbl'\:         a character table which must contain field 'order'
# \item 'chars'\:       *rational* characters of 'tbl'
# \item 'nonfaithful'\: $(1_{UN})^G$
# \item 'lower'\:       lower bounds for $(1_U)^G$
#                       (may be unspecified, i.e. 0)
# \item 'upper'\:       upper bounds for $(1_U)^G$
#                       (may be unspecified, i.e. 0)
# \item 'torso'\:       $(1_U)^G$ (at known positions)
# \item 'faithful'\:    'torso' - 'nonfaithful'
# \item 'divs'\:        'divs[i]' divides $(1_U)^G[i]$
# \end{itemize}
# 
# The algorithm proceeds in 5 steps\:
# 
# *step 1*\: Try to improve the input data
# \begin{enumerate}
# \item Check if 'torso[1]' divides $\|G\|$, 'nonfaithful[1]' divides
#       'torso[1]'.
# \item If 'orders[i]' does not divide $U$ 
#       or if $'nonfaithful[i]' = 0$, 'torso[i]' must be 0.
# \item Transfer 'upper' and 'lower' to upper bounds and lower bounds for
#       the values of 'faithful' and try to improve them\:
# \begin{enumerate}
# \item \['lower[i]'\:= \max\{'lower[i]',0\} - 'nonfaithful[i]';\]
#       If $UN$ has only one galois family of classes for a prime
#       representative order $p$, and $p$ divides $\|G\|/'torso[1]'$,
#       or if $g_i$ is a $p$-element and $p$ does not divide $[UN\:U]$,
#       then necessarily these elements lie in $U$, and we have
#       \['lower[i]'\:= \max\{'lower[i]',1\} - 'nonfaithful[i]';\]
# \item \begin{eqnarray*}
#       'upper[i]' & \:= & \min\{'upper[i]','torso[1]',
#                                'tbl.centralizers[i]'-1,\\
#       & & 'torso[1]' \cdot 'nonfaithful[i]'/'nonfaithful[1]'\}
#       -'nonfaithful[i]'.
#       \end{eqnarray*}
# \end{enumerate}
# \item Compute divisors of the values of $(1_U)^G$\:
#       \['divs[i]'\:= 'torso[1]'/\gcd\{'torso[1]',\|G\|/\|N_G[i]\|\}
#       \mbox{\rm \ divides} (1_U)^G[i].\]
#       ($\|N_G[i]\|$ denotes the normalizer order of $\langle g_i \rangle$.)
# 
#       If $g_i$ generates a Sylow $p$ subgroup of $UN$ and $p$ does not
#       divide $[UN\:U]$ then $(1_{UN})^G(g_i)$ divides $(1_U)^G(g_i)$,
#       and we have \['divs[i]'\:= 'Lcm( divs[i], nonfaithful[i] )'.\]
# \item Compute 'roots' and 'powers' for later improvements of local bounds\:
#       $j$ is in 'roots[i]' iff there exists a prime $p$ with powermap
#       stored on 'tbl' and $g_j^p = g_i$,
#       $j$ is in 'powers[i]' iff there exists a prime $p$ with powermap
#       stored on 'tbl' and $g_i^p = g_j$.
# \item Compute the list 'matrix' of possible constituents of 'faithful'\:
#       (If 'torso[1]' = 1, we have none.)
#       Every constituent $\chi$ must have degree $\chi(1)$ lower than
#       $'torso[1]' - 'nonfaithful[1]'$, and $N \not\subseteq \ker(\chi)$;
#       also, for all i, we must have
#       $\chi[i] \geq \chi[1] - 'faithful[1]' - 'nonfaithful[i]'$.
# \end{enumerate}
# 
# *step 2*\: Collapse classes which are equal for all possible constituents
# 
# (*Note*\: We only needed the fusion of classes, but we also have to make
#         a copy.)
# 
# After that, 'fusion' induces an equivalence relation of conjugacy classes,
# 'matrix' is the new list of constituents. Let $C \:= \{i_1,\ldots,i_n\}$
# be an equivalence class; for further computation, we have to adjust the
# other informations\:
# 
# \begin{enumerate}
# \item Collapse 'faithful'; the values that are not yet known later will be
#       filled in using the decomposability test (see "ContainedCharacters");
#       the equality 
#       \['torso' = 'nonfaithful' + 'Indirection'('faithful','fusion')\]
#       holds, so later we have
#       \[(1_U)^G = (1_{UN})^G + 'Indirection( faithful , fusion )'.\]
# \item Adjust the old structures\:
# \begin{enumerate}
# \item Define as new roots \[ 'roots[C]'\:=
#       \bigcup_{1 \leq j \leq n} 'set(Indirection(fusion,roots[i_j]))', \]
# \item as new powers \[ 'powers[C]'\:=
#       \bigcup_{1 \leq j \leq n} 'set(Indirection(fusion,powers[i_j]))',\]
# \item as new upper bound \['upper[C]'\:=
#       \min_{1 \leq j \leq n}('upper[i_j]'), \]
#       try to improve the bound using the fact that for each j in
#       'roots[C]' we have
#       \['nonfaithful[j]'+'faithful[j]' \leq
#       'nonfaithful[C]'+'faithful[C]',\]
# \item as new lower bound \['lower[C]'\:=
#       \max_{1 \leq j \leq n}('lower[i_j]'),\]
#        try to improve the bound using the fact that for each j in
#        'powers[C]' we have
#        \['nonfaithful[j]'+'faithful[j]' \geq
#        'nonfaithful[C]'+'faithful[C]',\]
# \item as new divisors \['divs[C]'\:=
#       'Lcm'( 'divs'[i_1],\ldots, 'divs'[i_n] ).\]
# \end{enumerate}
# \item Define some new structures\:
# \begin{enumerate}
# \item the moduls for the basechange \['moduls[C]'\:=
#          \max_{1 \leq j \leq n}('tbl.centralizers[i_j]'),\]
# \item new classes \['classes[C]'\:=
#          \sum_{1 \leq j \leq n} 'tbl.classes[i_j]',\]
# \item \['nonfaithsum[C]'\:= \sum_{1 \leq j \leq n} 'tbl.classes[i_j]'
#       \cdot 'nonfaithful[i_j]',\]
# \item a variable 'rest', preset with $\|G\|$\: We know that
#       $\sum_{g \in G} (1_U)^G(g) = \|G\|$.
#       Let the values of $(1_U)^G$ be known for a subset
#       $\tilde{G} \subseteq G$, and define
#       $'rest'\:= \sum_{g \in \tilde{G}} (1_U)^G(g)$;
#       then for $g \in G \setminus \tilde{G}$, we
#       have $(1_U)^G(g) \leq 'rest'/\|Cl_G(g)\|$.
#       In our situation, this means
#       \[\sum_{1 \leq j \leq n} \|Cl_G(g_j)\| \cdot (1_U)^G(g_j)
#       \leq 'rest',\]
#       or equivalently
#       $'nonfaithsum[C]' + 'faithful[C]' \cdot 'classes[C]' \leq 'rest'$.
#       (*Note* that 'faithful' necessarily is constant on 'C'.).
#       So 'rest' is used to update local upper bounds.
# \end{enumerate}
# \item (possible acceleration\: If we allow to collapse classes on which
#       'nonfaithful' takes different values, the situation is a little
#       more difficult. The new upper and lower bounds will be others,
#       and the new divisors will become moduls in a congruence relation
#       that has nothing to do with the values of torso or faithful.)
# \end{enumerate}
# 
# *step 3*\: Eliminate classes for which the values of 'faithful' are known
# 
# The subroutine 'erase' successively eliminates the columns of 'matrix'
# listed up in 'uniques'; at most one row remains with a nonzero entry 'val'
# in that column 'col', this is the gcd of the former column values.
# If we can eliminate 'difference[ col ]', we proceed with the next column,
# else there is a contradiction (i.e. no generalized character exists that
# satisfies our conditions), and we set 'impossible' true and then return
# all extracted rows which must be used at lower levels of a backtrack
# which may have called 'erase'.
# Having erased all uniques without finding a contradiction, 'erase' looks
# if other columns have become unique, i.e. the bounds and divisors allow
# just one value; those columns are erased, too.
# 'erase' also updates the (local) upper and lower bounds using 'roots',
# 'powers' and 'rest'.
# If no further elimination is possible, there can be two reasons\:
# If all columns are erased, 'faithful' is complete, and if it is really a
# character, it will be appended to 'possibilities'; then 'impossible' is
# set true to indicate that this branch of the backtrack search tree has
# ended here.
# Otherwise 'erase' looks for that column where the number of possible
# values is minimal, and puts a record with informations about first
# possible value, step (of the arithmetic progression) and number of
# values into that column of 'faithful';
# the number of the column is written to 'min\_class',
# 'impossible' is set false, and the extracted rows are returned.
# 
# And this way 'erase' computes the lists of possible values\:
# 
# Let $d\:= 'divs[ i ]', z\:= 'val', c\:= 'difference[ i ]',
# n\:= 'nonfaithful[ i ]', low\:= 'local\_lower[ i ]',
# upp\:= 'local\_upper[ i ]', g\:= \gcd\{d,z\} = ad + bz$.
# 
# Then the set of allowed values is
# \[ M\:= \{x; low \leq x \leq upp; x \equiv -c \pmod{z};
#              x \equiv -n \pmod{d} \}.\]
# If $g$ does not divide $c-n$, we have a contradiction, else
# $y\:= -n -ad \frac{c-n}{g}$ defines the correct arithmetic progression\:
# \[ M = \{x;low \leq x \leq upp; x \equiv y \pmod{'Lcm'(d,z)} \} \]
# The minimum of $M$ is then given by 
# \[ L\:= low + (( y - low ) \bmod 'Lcm'(d,z)).\]
# 
# (*Note* that for the usual case $d=1$ we have $a=1, b=0, y=-c$.)
# 
# Therefore the number of values is
# $'Int( '( upp - L ) ' / Lcm'(d,z) ' )' +1$.
# 
# In step 3, 'erase' is called with the list of known values of 'faithful'
# as 'uniques'.
# Afterwards, if 'InfoCharTable2 = Print' and a backtrack search is necessary,
# a message about the found improvements and the expected expense
# for the backtrack search is printed.
# (*Note* that we are allowed to forget the rows which we have extracted in
# this first elimination.)
# 
# *step 4*\: Delete eliminated columns physically before the backtrack search
# 
# The eliminated columns (those with 'nonzerocol[i] = false') of 'matrix'
# are deleted, and the other objects are adjusted\:
# \begin{enumerate}
# \item In 'differences', 'divs', 'nonzerocol', 'moduls', 'classes',
#       'nonfaithsum', 'upper', 'lower', the columns are simply deleted.
# \item For adjusting 'fusion', first a permutation 'fusionperm' is
#       constructed that maps the eliminated columns behind the remaining
#       columns; after 'faithful\:= Indirection( faithful, fusionperm )' and
#       'fusion\:= Indirection( fusionperm, fusion )', we have again
#       \[ (1_U)^G = (1_{UN})^G + 'Indirection( faithful, fusion )'. \]
# \item adjust 'roots' and 'powers'.
# \end{enumerate}
# 
# *step 5*\: The backtrack search
# 
# The subroutine 'evaluate' is called with a column 'unique'; this (and other
# uniques, if possible) is eliminated. If there was an inconsistence, the
# extracted rows are returned; otherwise the column 'min\_class' subsequently
# will be set to all possible values and 'evaluate' is called with
# 'unique = min\_class'.
# After each return from 'evaluate', the returned rows are appended to matrix
# again; if matrix becomes too long, a call of 'ModGauss' will shrink it.
# Note that 'erase' must be able to update the value of 'rest', but any call
# of 'evaluate' must not change 'rest'; so 'rest' is a parameter of
# 'evaluate', but for 'erase' it is global (realized as '[ rest ]').
 
PermCandidatesFaithful :=
   function( tbl, chars, norm_subgrp, nonfaithful, upper, lower, torso )

    local i, x, N, nccl, faithful, families, j, primes, orbits, factors,
          pparts, cyclics, divs, roots, powers, matrix, fusion, inverse,
          union, moduls, classes, nonfaithsum, rest, uniques, collfaithful, 
          orig_nonfaithful, difference, nonzerocol, possibilities,
          ischaracter, isnozerorow, erase, min_number, impossible, remain,
          ncha, pos, fusionperm, shrink, ppart, myset, newfaithful,
          min_class, evaluate, step, first, descendclass, oldrows, newmatrix,
          row;

    #
    # step 1: Try to improve the input data
    #
    lower:= Copy( lower );
    upper:= Copy( upper );
    torso:= Copy( torso );

    # order of normal subgroup
    N := Sum( Indirected( tbl.classes, norm_subgrp ) );
    nccl:= Length( nonfaithful );

    if not IsInt( torso[1] ) or torso[1] <= 0 then
      Error( "degree must be positive integer" );
    elif tbl.order mod torso[1] <> 0 or torso[1] mod nonfaithful[1] <> 0
         or torso[1] = 1 then
      return [];
    fi;
    for i in [ 1 .. nccl ] do
      if ( tbl.order / torso[1] ) mod tbl.orders[i] <> 0
         or nonfaithful[i] = 0 then
        if IsBound( torso[i] ) and IsInt( torso[i] ) and torso[i] <> 0 then
          return [];
        fi;
        torso[i]:= 0;
      fi;
    od;
    faithful:= [];
    for i in [ 1 .. Length( torso ) ] do
      if IsBound( torso[i] ) and IsInt( torso[i] ) then
        faithful[i]:= torso[i] - nonfaithful[i];
      fi;
    od;
    # compute a list of galois families for 'tbl':
    families:= [];
    for i in [ 1 .. nccl ] do
      if not IsBound( families[i] ) then
        families[i]:= ClassOrbitCharTable( tbl, i );
        for j in families[i] do families[j]:= families[i]; od;
      fi;
    od;
    # 'primes': prime divisors of $|U|$ for which there is only one $G$-family
    # of that element order in $UN$:
    primes:= Set( Factors( tbl.order / torso[1] ) );
    orbits:= [];
    for i in [ 1 .. Length( primes ) ] do orbits[i]:= []; od;
    for i in [ 1 .. nccl ] do
      if tbl.orders[i] in primes and nonfaithful[i] <> 0 then
        AddSet( orbits[ Position( primes, tbl.orders[i] ) ], families[i] );
      fi;
    od;
    for i in [ 1 .. Length( primes ) ] do
      if Length( orbits[i] ) <> 1 then primes[i]:= 1; fi;
    od;
    primes:= Difference( Set( primes ), [ 1 ] );
    
    # which Sylow subgroups of $UN$ are contained in $U$:
    
    factors:= Factors( tbl.order / torso[1] );
    pparts:= [];
    for i in Set( factors ) do
      if ( torso[1] / nonfaithful[1] ) mod i <> 0 then
        # i is a prime divisor of $\|U\|$ not dividing
        # $|UN|/|U| = 'torso[1] / nonfaithful[1]'$:
        ppart:= 1;
        for j in factors do
          if j = i then ppart:= ppart * i; fi;
        od;
        Add( pparts, ppart );
      fi;
    od;
    cyclics:= [];           # cyclic sylow subgroups
    for i in [ 1 .. nccl ] do
      if tbl.orders[i] in pparts and nonfaithful[i] <> 0 then
        Add( cyclics, i );
      fi;
    od;
    # transfer bounds:
    if lower = 0 then
      lower:= [ torso[1] ];
      for i in [ 2 .. nccl ] do lower[i]:= 0; od;
    fi;
    if upper = 0 then
      upper:= [];
      for i in [ 1 .. nccl ] do upper[i]:= torso[1]; od;
    fi;
    upper[1]:= upper[1] - nonfaithful[1];
    lower[1]:= lower[1] - nonfaithful[1];
    for i in [ 2 .. nccl ] do
      if nonfaithful[i] <> 0 and
         ( tbl.orders[i] in primes
           or 0 in List( pparts, x -> x mod tbl.orders[i] ) ) then
        lower[i]:= Maximum( lower[i], 1 ) - nonfaithful[i];
      else
        lower[i]:= Maximum( lower[i], 0 ) - nonfaithful[i];
      fi;
      if i in norm_subgrp then
        upper[i]:= Minimum( upper[i], torso[1], tbl.centralizers[i] - 1,
                   Int( ( N * nonfaithful[1] - torso[1] ) / tbl.classes[i] ),
                        Int( torso[1] * nonfaithful[i] / nonfaithful[1] ) )
                   - nonfaithful[i];
      else
        upper[i]:= Minimum( upper[i], torso[1], tbl.centralizers[i] - 1,
                        Int( torso[1] * nonfaithful[i] / nonfaithful[1] ) )
                   - nonfaithful[i];
      fi;
    od;
    for i in [ 1 .. nccl ] do
      if IsBound( faithful[i] ) then
        if faithful[i] >= lower[i] then
          lower[i]:= faithful[i];
        else
          return [];
        fi;
        if faithful[i] <= upper[i] then
          upper[i]:= faithful[i];
        else
          return [];
        fi;
      elif lower[i] = upper[i] then
        faithful[i]:= lower[i];
      fi;
    od;
    # compute divs:
    divs:= [ torso[1] ];
    for i in [ 2 .. nccl ] do
      divs[i]:= torso[1] / GcdInt( torso[1],
                  tbl.classes[i] * Length( families[i] )
                                              / Phi( tbl.orders[i] ) );
      if i in cyclics then
        divs[i]:= Lcm( divs[i], nonfaithful[i] );
      fi;
    od;
    # compute roots and powers:
    roots:= [];
    powers:= [];
    for i in [ 1 .. Length( nonfaithful ) ] do
      roots[i]:= [];
      powers[i]:= [];
    od;
    if IsBound( tbl.powermap ) then
      for i in [ 2 .. Length( tbl.powermap ) ] do
        if IsBound( tbl.powermap[i] ) then
          for j in [ 1 .. Length( nonfaithful ) ] do
            if IsInt( tbl.powermap[i][j] ) then
              AddSet( powers[j], tbl.powermap[i][j] );
              AddSet( roots[ tbl.powermap[i][j] ], j );
            fi;
          od;
        fi;
      od;
    fi;
    # matrix of constituents:
    matrix:= [];               # delete impossibles
    for i in chars do
      if i[1] <= faithful[1]
         and Difference( norm_subgrp, KernelChar( i ) ) <> [] then
        j:= 1;
        while j <= Length( i )
              and i[j] >= i[1] - faithful[1] - nonfaithful[j] do
          j:= j + 1;
        od;
        if j > Length( i ) then Add( matrix, i ); fi;
      fi;
    od;
    if matrix = [] then return []; fi;
    
    InfoCharTable2( "#I PermCandidatesFaithful : There are ",
                    Length( matrix ), " possible constituents,\n",
                    "#I    the number of unknown values is ",
                    Length( Filtered( [ 1 .. nccl ],
                            x -> not IsBound( faithful[x] ) ) ),
                    ";\n",
                    "#I    now trying to collapse the matrix\n" );
    
    #
    # step 2: Collapse classes which are equal for all possible constituents
    #
    matrix:= CollapsedMat( matrix, [ nonfaithful ] );
    fusion:= matrix.fusion;
    matrix:= matrix.mat;
    inverse:= [];
    for i in [ 1 .. Length( fusion ) ] do
      if IsBound( inverse[ fusion[i] ] ) then
        Add( inverse[ fusion[i] ], i );
      else
        inverse[ fusion[i] ]:= [ i ];
      fi;
    od;
    #
    myset:= function( obj )
    if IsInt( obj ) then return [ obj ]; else return obj; fi; end;
    #
    lower:= List( inverse, x -> Maximum( Sublist( lower, x ) ) );
    upper:= List( inverse, x -> Minimum( Sublist( upper, x ) ) );
    divs:=  List( inverse, x -> Lcm( Sublist( divs, x ) ) );
    moduls:= List( inverse, x -> Maximum( Sublist( tbl.centralizers, x ) ) );
    roots:= List( CompositionMaps( CompositionMaps( fusion, roots ),
                                                           inverse ), myset );
    powers:= List( CompositionMaps( CompositionMaps( fusion, powers ),
                                                           inverse ), myset );
    classes:= [];
    for i in [ 1 .. Length( moduls ) ] do classes[i]:= 0; od;
    for i in [ 1 .. Length( inverse ) ] do
      for j in inverse[i] do classes[i]:= classes[i] + tbl.classes[j]; od;
    od;
    nonfaithsum:= [];
    for i in [ 1 .. Length( moduls ) ] do nonfaithsum[i]:= 0; od;
    for i in [ 1 .. Length( inverse ) ] do
      for j in inverse[i] do
        nonfaithsum[i]:= nonfaithsum[i] + tbl.classes[j] * nonfaithful[j];
      od;
    od;
    rest:= tbl.order;
    nccl:= Length( moduls );
    uniques:= [];
    collfaithful:= [];
    for i in [ 1 .. Length( fusion ) ] do
      if IsBound( faithful[i] ) then
        if IsBound( collfaithful[ fusion[i] ] ) then
          if collfaithful[ fusion[i] ] <> faithful[i] then return []; fi;
        else
          collfaithful[ fusion[i] ]:= faithful[i];
          Add( uniques, fusion[i] );
          rest:= rest - classes[fusion[i]] * ( faithful[i] + nonfaithful[i] );
          if rest < 0 then return [];  fi;
        fi;
      fi;
    od;
    faithful:= collfaithful;
    orig_nonfaithful:= Copy( nonfaithful );
    nonfaithful:= CompositionMaps( nonfaithful, inverse );
    # improvement of bounds by use of roots and powers
    for i in [ 1 .. nccl ] do
      if IsBound( faithful[i] ) then
        for j in roots[i] do
          upper[j]:= Minimum( upper[j],
                              nonfaithful[i] + faithful[i] - nonfaithful[j] );
        od;
        for j in powers[i] do
          lower[j]:= Maximum( lower[j],
                              nonfaithful[i] + faithful[i] - nonfaithful[j] );
        od;
      fi;
    od;
    
    InfoCharTable2( "#I PermCandidatesFaithful : There are ", nccl,
                    " families of classes left,\n",
                    "#I    the number of unknown values is ",
                    nccl - Length( uniques ), ",\n",
                    "#I    the numbers of possible values for each class are",
                    " appropriately\n",
                    "#I    ",
                    List( [ 1 .. nccl ],
                          x -> Int( ( upper[x] - lower[x] ) / divs[x] )+1),
                    ";\n#I    now eliminating known classes\n" );
    
    #
    # step 3: Eliminate classes for which the values of 'faithful' are known
    #
    difference:= [];
    for i in [ 1 .. Length( moduls ) ] do difference[i]:= 0; od;
    nonzerocol:= [];
    for i in [ 1 .. Length( moduls ) ] do nonzerocol[i]:= true; od;
    possibilities:= [];     # global list of permutation character candidates
    #
    # two little functions:
    #
    ischaracter:= function( gencharacter )
      local i, sum, classes, cand;
      classes:= tbl.classes;
      cand:= [];
      for i in [ 1 .. Length( gencharacter ) ] do
        cand[i]:= gencharacter[i] * classes[i];
      od;
      for i in chars do
        sum:= cand * i;
        if sum < 0 then return false; fi;
      od;
      return true;
    end;
    #
    isnozerorow:= function( row )
      local i;
      for i in row do if i <> 0 then return true; fi; od;
      return false;
    end;
    #
    # and a bigger function:
    #
    erase:= function( uniques, nonzerocol, difference, rest, locupp, loclow )
    # eliminate all unique columns, adapt nonzerocol;
    # then look if other columns become unique or if a contradiction occurs;
    # also look at which column the least number of values is left
    local i, j, extracted, col, row, quot, val, ggt, a, b, k, u, anzahl, elm,
          firstallowed, step, gencharacter, remain, update, newupdate,
          c, upp, low, g, st, y, L, number;
    extracted:= [];
    while uniques <> [] do
      for col in uniques do
        if col < 0 then       # col is zerocol, known from val = moduls[i]
          col:= -col;
          difference[ col ]:= ( difference[ col ] + faithful[ col ] )
                                                        mod moduls[ col ];
          if difference[ col ] <> 0 then
            impossible:= true;
            return extracted;
          fi;
        else
          difference[ col ]:=
                          ( difference[ col ] + faithful[ col ] )
                                                        mod moduls[ col ];
          row:= StepModGauss( matrix, moduls, nonzerocol, col );
          if row = false then
            if difference[ col ] <> 0 then
              impossible:= true;
              return extracted;
            fi;
          else 
            # delete zero rows:
            shrink:= [];
            for i in matrix do
               if isnozerorow( i ) then Add( shrink, i ); fi;
            od;
            matrix:= shrink;
            #
            Add( extracted, row );
            if difference[col] mod row[col] <> 0 then
              impossible:= true;
              return extracted;
            fi;
            quot:= difference[col] / row[col];
            for j in [ 1 .. nccl ] do
              if nonzerocol[j] then
                difference[j]:= ( difference[j] - quot * row[j] )
                                                           mod moduls[j];
              fi;
            od;
          fi;
        fi;
        nonzerocol[col]:= false;
        locupp[ col ]:= faithful[ col ];
        loclow[ col ]:= faithful[ col ];
    #   update:= [ col ];
    #   while update <> [] do
    #     newupdate:= [];
    #     for k in update do
    #       for elm in roots[k] do
    #         if nonzerocol[ elm ] then
    #           if locupp[ elm ] >
    #              locupp[k] + nonfaithful[k] - nonfaithful[ elm ] then
    #             AddSet( newupdate, elm );
    #             locupp[ elm ]:= locupp[k] + nonfaithful[k]
    #                             - nonfaithful[ elm ];
    #           fi;
    #         fi;
    #       od;
    #     od;
    #     update:= newupdate;
    #   od;
    #   update:= [ col ];
    #   while update <> [] do
    #     newupdate:= [];
    #     for k in update do
    #       for elm in powers[k] do
    #         if nonzerocol[ elm ] then
    #           if loclow[ elm ] < loclow[k]
    #                          + nonfaithful[k] - nonfaithful[ elm ] then
    #             AddSet( newupdate, elm );
    #             loclow[ elm ]:= loclow[k] + nonfaithful[k]
    #                             - nonfaithful[ elm ];
    #           fi;
    #         fi;
    #       od;
    #     od;
    #     update:= newupdate;
    #   od;
      od;
    # now all yet known uniques have been erased, try to find new ones
      min_number:= "infinity";
      uniques:= [];
      for i in [ 1 .. nccl ] do
        if nonzerocol[i] then
          val:= moduls[i];
          for j in matrix do val:= GcdInt( val, j[i] ); od;
                                             # zerocol iff val = moduls[i]
          c:= difference[i] mod val;         # now >= 0
          upp:= Minimum( locupp[i], ( rest[1] - nonfaithsum[i] )/classes[i] );
          low:= loclow[i];
          g:= Gcdex( divs[i], val );
          a:= g.coeff1;
          b:= g.coeff2;
          g:= g.gcd;
          if ( c - nonfaithful[i] ) mod g <> 0 then
            impossible:= true;
            return extracted;
          fi;
          st:= divs[i] * val / g;
          y:= - nonfaithful[i] - ( a * divs[i] * ( c - nonfaithful[i] ) ) / g;
          L:= low + ( ( y - low ) mod st);
          if upp < L then
            impossible:= true;
            return extracted;
          else
            number:= Int( ( upp - L ) / st ) + 1;
            if number = 1 then         # unique
              faithful[i]:= L;
              if val = moduls[i] then
                Add( uniques, -i );    # no StepModGauss necessary
              else
                Add( uniques, i );
              fi;
              rest[1]:= rest[1] - classes[i] * faithful[i] - nonfaithsum[i];
            elif number < min_number then
              min_number:= number;
              step:= st;
              firstallowed:= L;
              min_class:= i;
            fi;
          fi;
        fi;
      od;
    od;
    if min_number = "infinity" then
      if rest[1] = 0 then
        gencharacter:= Indirected( faithful, fusion ) + orig_nonfaithful;
        if ischaracter( gencharacter ) and TestPerm1( tbl, gencharacter ) = 0
           and TestPerm2( tbl, gencharacter ) = 0 then
          Add( possibilities, gencharacter );
        fi;
      fi;
      impossible:= true;
    else
      faithful[ min_class ]:= rec( firstallowed:= firstallowed, # first value
                                   step:= step,                 # step
                                   number:= min_number );
      impossible:= false;
    fi;
    return extracted;
    # impossible = true: calling function will return from backtrack
    # impossible = false: then min_class < E( 3 ), and faithful[ min_class ]
    #                 contains the informations for descending at min_class
    end;
    #
    rest:= [ rest ];
    erase( uniques, nonzerocol, difference, rest, upper, lower );
    rest:= rest[1];
    if impossible then return possibilities; fi;
    
    InfoCharTable2( "#I PermCandidatesFaithful : A backtrack search",
                    " will be needed;\n",
                    "#I    now physically deleting known classes\n" );
    
    #
    # step 4: Delete eliminated columns physically before the backtrack search
    #
    remain:= Filtered( [ 1 .. nccl ], x->nonzerocol[x] );
    for i in [ 1 .. Length( matrix ) ] do
      matrix[i]:= Sublist( matrix[i], remain );
    od;
    difference:=    Sublist( difference, remain );
    divs:=          Sublist( divs, remain );
    nonzerocol:=    Sublist( nonzerocol, remain );
    moduls:=        Sublist( moduls, remain );
    classes:=       Sublist( classes, remain );
    nonfaithsum:=   Sublist( nonfaithsum, remain );
    nonfaithful:=   Sublist( nonfaithful, remain );
    upper:=         Sublist( upper, remain );
    lower:=         Sublist( lower, remain );
    matrix:= ModGauss( matrix, moduls );
    ncha:= Length( matrix );
    pos:= 1;
    fusionperm:= [];
    for i in [ 1 .. nccl ] do
      if i in remain then
        fusionperm[ i ]:= pos;
        pos:= pos + 1;
      fi;
    od;
    for i in Difference( [ 1 .. nccl ], remain ) do
      fusionperm[i]:= pos;
      pos:= pos + 1;
    od;  
    min_class:= fusionperm[ min_class ];
    newfaithful:= [];
    for i in [ 1 .. Length( faithful ) ] do
      if IsBound( faithful[i] ) then
        newfaithful[ fusionperm[i] ]:= faithful[i];
      fi;
    od;
    faithful:= newfaithful;
    fusion:= CompositionMaps( fusionperm, fusion );
    for i in remain do
      roots[ fusionperm[i] ]:= CompositionMaps( fusionperm,
                                     Intersection( roots[i], remain ) );
      powers[ fusionperm[i] ]:= CompositionMaps( fusionperm,
                                     Intersection( powers[i], remain ) );
    od;
    nccl:= Length( nonzerocol );
    
    InfoCharTable2( "#I PermCandidatesFaithful:",
                    " The number of unknown values is ", nccl, ";\n",
                    "#I    the numbers of possible values for each class are",
                    " appropriately\n#I    ",
                    List( [ 1 .. nccl ],
                          x -> Int( ( upper[x] - lower[x] ) / divs[x]+1)),
                    "\n#I    now beginning the backtrack search\n" );
    
    #
    # step 5: The backtrack search
    #
    evaluate:=
          function(difference,rest,nonzerocol,unique,local_upper,local_lower)
    local i, j, col, val, row, quot, extracted, step, first, descendclass;
    rest:= [ rest ];
    extracted:= erase( [ unique ], nonzerocol, difference, rest, local_upper,
                       local_lower );
    rest:= rest[1];
    if impossible then return extracted; fi;
    descendclass:= min_class;
    step:= faithful[ descendclass ].step;
    first:= faithful[ descendclass ].firstallowed;
    rest:= rest + ( step - first ) * classes[ descendclass ]
                - nonfaithsum[ descendclass ];
    for i in [ 1 .. min_number ] do
      faithful[ descendclass ]:= first + (i-1) * step;
      rest:= rest - step * classes[ descendclass ];
      oldrows:= evaluate( Copy(difference), rest, Copy( nonzerocol ),
                          descendclass, Copy( local_upper ),
                          Copy( local_lower ) );
      Append( matrix, oldrows );
      if Length( matrix ) > ( 3 * ncha ) / 2 then
        newmatrix:= [];
        for j in [ 1 .. Length( matrix[1] ) ] do
          if nonzerocol[j] then
            row:= StepModGauss( matrix, moduls, nonzerocol, j );
            if row <> false then Add( newmatrix, row ); fi;
          fi;
        od;
        matrix:= newmatrix;
      fi;
    od;
    return extracted;
    end;
    
    #
    
    step:= faithful[min_class].step;
    first:= faithful[min_class].firstallowed;
    descendclass:= min_class;
    rest:= rest + ( step - first ) * classes[ descendclass ]
                - nonfaithsum[ descendclass ];
    for i in [ 1 .. min_number ] do
      faithful[ descendclass ]:= first + (i-1) * step;
      rest:= rest - step * classes[ descendclass ];
      oldrows:= evaluate( Copy(difference), rest, Copy( nonzerocol ),
                descendclass, Copy( upper ), Copy( lower ) );
      Append( matrix, oldrows );
      if Length( matrix ) > ( 3 * ncha ) / 2 then
        newmatrix:= [];
        for j in [ 1 .. Length( matrix[1] ) ] do
          if nonzerocol[j] then
            row:= StepModGauss( matrix, moduls, nonzerocol, j );
            if row <> false then Add( newmatrix, row ); fi;
          fi;
        od;
        matrix:= newmatrix;
      fi;
    od;
    return possibilities;
    end;


#############################################################################
##
#F  PermChars( <tbl> [, <arec>] ) . . . . . . . . . . 06 Aug 91
##
##  Find all Candidates for Permutation Characters of the group with
##  Character table <tbl> by use of an algorithm specified by choice of
##  the arguments.
##
PermChars := function(arg)

   local tbl, arec, fields;

   if Length(arg) = 1 then
      tbl:= arg[1];
      arec:= rec();
   elif Length(arg) = 2 then
      tbl:= arg[1];
      if IsRec(arg[2]) then
        arec:= arg[2];
      else
        arec:= rec(degree:= arg[2]);
      fi;
   else

      Error( "usage: PermChars(<tbl>), PermChars(<tbl>, <degree>) or\n",
             "       PermChars(<tbl>, <arec>)" );

   fi;

   fields:= RecFields(arec);
   if IsSubset(fields, ["degree"]) and IsInt(arec.degree) then
      return PermComb(tbl, arec);
   elif IsSubset(fields, ["normalsubgrp", "nonfaithful", 
                    "chars", "lower", "upper", "torso"]) then
      return PermCandidatesFaithful(tbl, arec.chars, arec.normalsubgrp,
            arec.nonfaithful, arec.upper, arec.lower, arec.torso);
   elif IsSubset(fields, ["torso", "chars"]) then
      return PermCandidates(tbl, arec.chars, arec.torso);
   else
      return Permut(tbl, arec);
   fi;
end;


#############################################################################
##
#F  PermCharInfo( <tbl>, <permchars> )
##
##  Let <tbl> be the character table of the group $G$, and 'permchars' the
##  permutation character $(1_U)^G$ for a subgroup $U$ of $G$, or a list
##  of such permutation characters.
##  'PermCharInfo' returns a record with components
##
##  'contained':\\
##    a list containing for each character in <permchars> a list containing
##    at position <i> the number of elements of $U$ that are contained in
##    class <i> of <tbl>, this is equal to
##    $'permchar[<i>]' \|U\| / 'tbl.centralizers[<i>]',
##    
##  'bound':\\
##    a list containing for each character in <permchars> a list containing
##    at position <i> the class length in $U$ of an element in class <i>
##    of <tbl> must be a multiple of
##    $'bound[<i>]' = \|U\| / \gcd( \|U\|, <tbl>.centralizers[<i>] )$,
##
##  'display':\\
##    record that can be used as second argument of 'DisplayCharTable'
##    to display each permutation character in <permchars> and the
##    corresponding components 'contained' and 'bound',
##    for the classes where at least one permutation character is nonzero,
##
##  'ATLAS':\\
##    list of strings containing the decomposition of the permutation
##    characters into '<tbl>.irreducibles' in {\ATLAS} notation.
##
PermCharInfo := function( tbl, permchars )

    local i, j, k, order, cont, bound, alp, degreeset, irreds, chi,
          ATLAS, ATL, error, scprs, cont1, bound1, char, chars;

    cont  := [];
    bound := [];
    ATL   := [];
    chars := [];

    if not IsList( permchars[1] ) then
      permchars:= [ permchars ];
    fi;

    for char in permchars do
      cont1  := [];
      bound1 := [];
      order  := tbl.order / char[1];
      for i in [ 1 .. Length( char ) ] do
        cont1[i]  := char[i] * order / tbl.centralizers[i];
        bound1[i] := order / GcdInt( order, tbl.centralizers[i] );
      od;
      Add( cont, cont1 );
      Add( bound, bound1 );
      Append( chars, [ char, cont1, bound1 ] );
    od;

    if IsBound( tbl.irreducibles ) then

      # compute the 'ATLAS' component
      alp:= [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
              "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
              "w", "x", "y", "z" ];
      degreeset:= Set( List( tbl.irreducibles, x -> x[1] ) );

      # 'irreds[i]' contains all irreducibles of the 'i'--th degree
      irreds:= List( degreeset, x -> [] );
      for chi in tbl.irreducibles do
        Add( irreds[ Position( degreeset, chi[1] ) ], chi );
      od;

      # extend the alphabet if necessary
      while Length( alp ) < Maximum( List( irreds, Length ) ) do
        alp:= Concatenation( alp,
               List( alp, x -> ConcatenationString( "(", x, "')" ) ) );
      od;

      ATLAS:= [];
      for char in permchars do

        ATL:= "";
        error:= false;
        for i in irreds do
          scprs:= List( i, x -> ScalarProduct( tbl, char, x ) );
          if ForAny( scprs, x -> x < 0 ) then
            scprs:= Filtered( [ 1 .. Length( scprs ) ], x -> scprs[x] <  0 );
            scprs:= List( scprs, x -> Position( tbl.irreducibles, i[x] ) );
            Print( "#E PermCharInfo: negative scalar product(s) with X",
                   scprs, "\n" );
            error:= true;
          elif ForAny( scprs, x -> x > 0 ) then
            if ATL <> "" then
              ATL:= ConcatenationString( ATL, "+" );
            fi;
            ATL:= ConcatenationString( ATL, String( i[1][1] ) );
            for j in [ 1 .. Length( scprs ) ] do
              if   scprs[j] = 1 then
                ATL:= ConcatenationString( ATL, alp[j] );
              elif scprs[j] = 2 then
                ATL:= ConcatenationString( ATL, alp[j], alp[j] );
              elif scprs[j] = 3 then
                ATL:= ConcatenationString( ATL, alp[j], alp[j], alp[j] );
              elif scprs[j] > 3 then
                ATL:= ConcatenationString( ATL, alp[j], "^{",
                                           String( scprs[j] ), "}" );
              fi;
            od;
          fi;
        od;
        if error then ATL:= "Error"; fi;
        Add( ATLAS, ATL );
      od;
    else
      ATLAS:= "error, no irreducibles bound";
    fi;

    return rec( contained:= cont, bound:= bound,
                display:= rec( classes:= Filtered([1..Length(tbl.classes)],
                                  x -> ForAny( permchars, y -> y[x]<>0 ) ),
                               chars:= chars,
                               letter:= "I"                               ),
                ATLAS:= ATLAS );
    end; 


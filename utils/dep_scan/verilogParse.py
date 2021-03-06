#
# verilogParse.py
#
# an example of using the pyparsing module to be able to process Verilog files
# uses BNF defined at http://www.verilog.com/VerilogBNF.html
#
#    Copyright (c) 2004-2011 Paul T. McGuire.  All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# If you find this software to be useful, please make a donation to one
# of the following charities:
# - the Red Cross (http://www.redcross.org)
# - Hospice Austin (http://www.hospiceaustin.org)
#
#    DISCLAIMER:
#    THIS SOFTWARE IS PROVIDED BY PAUL T. McGUIRE ``AS IS'' AND ANY EXPRESS OR
#    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#    EVENT SHALL PAUL T. McGUIRE OR CO-CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
#    INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
#    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OFUSE,
#    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
#    OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#    NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
#    EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#    For questions or inquiries regarding this license, or commercial use of
#    this software, contact the author via e-mail: ptmcg@users.sourceforge.net
#
# Todo:
#  - add pre-process pass to implement compilerDirectives (ifdef, include, etc.)
#
# Revision History:
#
#   1.0   - Initial release
#   1.0.1 - Fixed grammar errors:
#           . real declaration was incorrect
#           . tolerant of '=>' for '*>' operator
#           . tolerant of '?' as hex character
#           . proper handling of mintypmax_expr within path delays
#   1.0.2 - Performance tuning (requires pyparsing 1.3)
#   1.0.3 - Performance updates, using Regex (requires pyparsing 1.4)
#   1.0.4 - Performance updates, enable packrat parsing (requires pyparsing 1.4.2)
#   1.0.5 - Converted keyword Literals to Keywords, added more use of Group to
#           group parsed results tokens
#   1.0.6 - Added support for module header with no ports list (thanks, Thomas Dejanovic!)
#   1.0.7 - Fixed erroneous '<<' Forward definition in timCheckCond, omitting ()'s
#   1.0.8 - Re-released under MIT license
#   1.0.9 - Enhanced udpInstance to handle identifiers with leading '\' and subscripting
#   1.0.10 - Fixed change added in 1.0.9 to work for all identifiers, not just those used
#           for udpInstance.
#
import pdb
import time
import pprint
import sys

__version__ = "1.0.10"

from pyparsing import Literal, CaselessLiteral, Keyword, Word, OneOrMore, ZeroOrMore, \
        Forward, NotAny, delimitedList, Group, Optional, Combine, alphas, nums, restOfLine, cStyleComment, \
        alphanums, printables, dblQuotedString, empty, ParseException, ParseResults, MatchFirst, oneOf, GoToColumn, \
        ParseResults,StringEnd, FollowedBy, ParserElement, And, Regex, cppStyleComment#,__version__
import pyparsing
usePackrat = True
usePsyco = False

packratOn = False
psycoOn = False

if usePackrat:
    try:
        ParserElement.enablePackrat()
    except:
        pass
    else:
        packratOn = True

# comment out this section to disable psyco function compilation
if usePsyco:
    try:
        import psyco
        psyco.full()
    except:
        print( "failed to import psyco Python optimizer")
    else:
        psycoOn = True


def dumpTokens(s,l,t):
    import pprint
    pprint.pprint( t.asList() )

module_hier = dict()
module_now = ""

def parseModule(s, l, t):
    global module_hier
    global module_now
    module_now = t[0]
    module_hier[module_now] = set()

def parseSubmod(s, l, t):
    global module_hier
    global module_now
    module_hier[module_now].add(t[0])

verilogbnf = None
def Verilog_BNF():
    global verilogbnf

    if verilogbnf is None:

        # compiler directives
        compilerDirective = Combine( "`" + \
            oneOf("define undef ifdef else endif default_nettype "
                  "include resetall timescale unconnected_drive "
                  "nounconnected_drive celldefine endcelldefine") + \
            restOfLine ).setName("compilerDirective")

        # primitives
        semi = Literal(";")
        lpar = Literal("(")
        rpar = Literal(")")
        equals = Literal("=")

        identLead = alphas+"$_"
        identBody = alphanums+"$_"
        identifier1 = Regex( r"\.?["+identLead+r"]["+identBody+r"]*(\.["+identLead+r"]["+identBody+r"]*)*"
                            ).setName("baseIdent")
        identifier2 = Regex(r"\\\S+").setParseAction(lambda t:t[0][1:]).setName("escapedIdent")
        identifier = (identifier1 | identifier2).setName("id")#.setDebug()
        
        hexnums = nums + "abcdefABCDEF" + "_?"
        base = Regex("'[sS]?[bBoOdDhH]").setName("base")
        basedNumber = Combine( Optional( Word(nums + "_") ) + base + Word(hexnums+"xXzZ"),
                               joinString=" ", adjacent=False ).setName("basedNumber")
        #~ number = ( basedNumber | Combine( Word( "+-"+spacedNums, spacedNums ) +
                           #~ Optional( "." + Optional( Word( spacedNums ) ) ) +
                           #~ Optional( e + Word( "+-"+spacedNums, spacedNums ) ) ).setName("numeric") )
        number = ( basedNumber | \
                   Regex(r"[+-]?[0-9_]+(\.[0-9_]*)?([Ee][+-]?[0-9_]+)?") \
                  ).setName("numeric")
        #~ decnums = nums + "_"
        #~ octnums = "01234567" + "_"
        expr = Forward().setName("expr")#.setDebug()
        concat = Group( "{" + delimitedList( expr ) + "}" )
        multiConcat = Group("{" + expr + concat + "}").setName("multiConcat")
        funcCall = Group(identifier + "(" + Optional( delimitedList( expr ) ) + ")").setName("funcCall")

        subscrRef = Group("[" + delimitedList( expr, ":" ) + "]")
        subscrIdentifier = Group( identifier + Optional( subscrRef ) )
        #~ scalarConst = "0" | (( FollowedBy('1') + oneOf("1'b0 1'b1 1'bx 1'bX 1'B0 1'B1 1'Bx 1'BX 1") ))
        scalarConst = Regex("0|1('[Bb][01xX])?")
        mintypmaxExpr = Group( expr + ":" + expr + ":" + expr ).setName("mintypmax")
        primary = (
                  number |
                  ("(" + mintypmaxExpr + ")" ) |
                  ( "(" + Group(expr) + ")" ).setName("nestedExpr") | #.setDebug() |
                  multiConcat |
                  concat |
                  dblQuotedString |
                  funcCall |
                  subscrIdentifier
                  )

        unop  = ( Literal("+") | Literal("-") | Literal("!") | Literal("~") | Literal("&") | Literal("~&") | Literal("|") | Literal("^|") | Literal("^") | Literal("~^") ) #oneOf( r"+  -  !  ~  &  ~&  |  ^|  ^  ~^" ).setName("unop").setDebug()
        binop = oneOf( r"+  -  *  /  %  ==  !=  ===  !==  &&  "
                       "||  <  <=  >  >=  &  |  ^  ~^ ^~  >>  << ** <<< >>>" ).setName("binop")#.setDebug()

        expr << (
                ( unop + expr ) |  # must be first!
                ( primary + "?" + expr + ":" + expr ) |
                ( primary + Optional( binop + expr ) )
                )

        lvalue = subscrIdentifier | concat

        # keywords
        if_        = Keyword("if")
        else_      = Keyword("else")
        edge       = Keyword("edge")
        posedge    = Keyword("posedge")
        negedge    = Keyword("negedge")
        specify    = Keyword("specify")
        endspecify = Keyword("endspecify")
        fork       = Keyword("fork")
        join       = Keyword("join")
        begin      = Keyword("begin")
        end        = Keyword("end")
        default    = Keyword("default")
        forever    = Keyword("forever")
        repeat     = Keyword("repeat")
        while_     = Keyword("while")
        for_       = Keyword("for")
        case       = oneOf( "case casez casex" )
        endcase    = Keyword("endcase")
        wait       = Keyword("wait")
        disable    = Keyword("disable")
        deassign   = Keyword("deassign")
        force      = Keyword("force")
        release    = Keyword("release")
        assign     = Keyword("assign")# .setName("assign").setDebug()
        genvar     = Keyword("genvar")
        generate   = Keyword("generate")
        endgenerate   = Keyword("endgenerate")
        localparam = Keyword("localparam")

        eventExpr = Forward()
        eventTerm = ( posedge + expr ) | ( negedge + expr ) | expr | ( "(" + eventExpr + ")" )
        eventExpr << (
            Group( delimitedList( eventTerm, "or" ) )
            )
        eventControl = Group( "@" + ( ( "(" + eventExpr + ")" ) | identifier | "*" | ( Literal("(") + Literal("*") + Literal(")") ) ) ).setName("eventCtrl")#.setDebug()

        delayArg = ( number |
                     Word(alphanums+"$_") | #identifier |
                     ( "(" + Group( delimitedList( mintypmaxExpr | expr ) ) + ")" )
                   ).setName("delayArg")#.setDebug()
        delay = Group( "#" + delayArg ).setName("delay")#.setDebug()
        delayOrEventControl = delay | eventControl

        assgnmt   = Group( lvalue + "=" + Optional( delayOrEventControl ) + expr ).setName( "assgnmt" )#.setDebug()
        nbAssgnmt = Group(( lvalue + "<=" + Optional( delay ) + expr ) |
                     ( lvalue + "<=" + Optional( eventControl ) + expr )).setName( "nbassgnmt" )

        range = "[" + expr + ":" + expr + "]"

        paramAssgnmt = Group( identifier + "=" + expr ).setName("paramAssgnmt")
        listsOfParamAssignments = Optional( range | "integer" | "real" ) + delimitedList( paramAssgnmt )
        parameterDecl = Group( "parameter" + listsOfParamAssignments + semi).setName("paramDecl")#.setDebug()
        localparamDecl = Group( localparam + listsOfParamAssignments + semi).setName("localparamDecl")

        inputDecl = Group( "input" + Optional( range ) + delimitedList( identifier ) + semi )
        outputDecl = Group( "output" + Optional( range ) + delimitedList( identifier ) + semi )
        inoutDecl = Group( "inout" + Optional( range ) + delimitedList( identifier ) + semi )

        regIdentifier = Group( identifier + Optional( "[" + expr + ":" + expr + "]" ) )
        regDecl = Group( "reg" + Optional("signed") + Optional( range ) + delimitedList( regIdentifier ) + semi ).setName("regDecl")
        timeDecl = Group( "time" + delimitedList( regIdentifier ) + semi )
        integerDecl = Group( "integer" + delimitedList( regIdentifier ) + semi )

        strength0 = oneOf("supply0  strong0  pull0  weak0  highz0")
        strength1 = oneOf("supply1  strong1  pull1  weak1  highz1")
        driveStrength = Group( "(" + ( ( strength0 + "," + strength1 ) |
                                       ( strength1 + "," + strength0 ) ) + ")" ).setName("driveStrength")
        nettype = ( Keyword("wire") | Keyword("tri") | Keyword("tri1") | 
                Keyword("supply0") | Keyword("wand") | Keyword("triand") | 
                Keyword("tri0") | Keyword("supply1") | Keyword("wor") | 
                Keyword("trior") | Keyword("trireg") )
        expandRange = Optional( oneOf("scalared vectored") ) + range
        realDecl = Group( "real" + delimitedList( identifier ) + semi )

        eventDecl = Group( "event" + delimitedList( identifier ) + semi )

        blockDecl = (
            localparamDecl|
            parameterDecl |
            regDecl |
            integerDecl |
            realDecl |
            timeDecl |
            eventDecl
            )

        stmt = Forward().setName("stmt")#.setDebug()
        stmtOrNull = stmt | semi
        caseItem = ( delimitedList( expr ) + ":" + stmtOrNull ) | \
                   ( default + Optional(":") + stmtOrNull )
        
        forHdr = ( for_ + "(" + assgnmt + semi + Group( expr ) + semi + assgnmt + ")" )

        stmt << Group(
            ( begin + Group( ZeroOrMore( stmt ) ) + end ).setName("begin-end") |
            ( if_ + Group("(" + expr + ")") + stmtOrNull + Optional( else_ + stmtOrNull ) ).setName("if") |
            ( delayOrEventControl + stmtOrNull ) |
            ( case + "(" + expr + ")" + OneOrMore( caseItem ) + endcase ).setName("case") |
            ( forever + stmt ) |
            ( repeat + "(" + expr + ")" + stmt ) |
            ( while_ + "(" + expr + ")" + stmt ) |
            ( forHdr + stmt ) |
            ( fork + ZeroOrMore( stmt ) + join ) |
            ( fork + ":" + identifier + ZeroOrMore( blockDecl ) + ZeroOrMore( stmt ) + end ) |
            ( wait + "(" + expr + ")" + stmtOrNull ) |
            ( "->" + identifier + semi ) |
            ( disable + identifier + semi ) |
            ( assign + assgnmt + semi ) |
            ( deassign + lvalue + semi ) |
            ( force + assgnmt + semi ) |
            ( release + lvalue + semi ) |
            ( begin + ":" + identifier + ZeroOrMore( blockDecl ) + ZeroOrMore( stmt ) + end ).setName("begin:label-end") |
            # these  *have* to go at the end of the list!!!
            ( assgnmt + semi ) |
            ( nbAssgnmt + semi ) |
            ( Combine( Optional("$") + identifier ) + Optional( "(" + delimitedList(expr|empty) + ")" ) + semi )
            ).setName("stmtBody")
        """
        x::=<blocking_assignment> ;
        x||= <non_blocking_assignment> ;
        x||= if ( <expression> ) <statement_or_null>
        x||= if ( <expression> ) <statement_or_null> else <statement_or_null>
        x||= case ( <expression> ) <case_item>+ endcase
        x||= casez ( <expression> ) <case_item>+ endcase
        x||= casex ( <expression> ) <case_item>+ endcase
        x||= forever <statement>
        x||= repeat ( <expression> ) <statement>
        x||= while ( <expression> ) <statement>
        x||= for ( <assignment> ; <expression> ; <assignment> ) <statement>
        x||= <delay_or_event_control> <statement_or_null>
        x||= wait ( <expression> ) <statement_or_null>
        x||= -> <name_of_event> ;
        x||= <seq_block>
        x||= <par_block>
        x||= <task_enable>
        x||= <system_task_enable>
        x||= disable <name_of_task> ;
        x||= disable <name_of_block> ;
        x||= assign <assignment> ;
        x||= deassign <lvalue> ;
        x||= force <assignment> ;
        x||= release <lvalue> ;
        """
        alwaysStmt = Group( "always" + Optional(eventControl) + stmt ).setName("alwaysStmt")
        initialStmt = Group( "initial" + stmt ).setName("initialStmt")

        chargeStrength = Group( "(" + oneOf( "small medium large" ) + ")" ).setName("chargeStrength")

        continuousAssign = Group(
            assign + Optional( driveStrength ) + Optional( delay ) + delimitedList( assgnmt ) + semi
            ).setName("continuousAssign")#.setDebug()


        tfDecl = (
            parameterDecl |
            inputDecl |
            outputDecl |
            inoutDecl |
            regDecl |
            timeDecl |
            integerDecl |
            realDecl
            )

        inputOutput = (Keyword("input") | Keyword("output"))
        netDecl1Arg = ( nettype + 
            Optional("signed") + 
            Optional( expandRange ) +
            Optional( delay ) +
            Group( delimitedList( ~inputOutput + identifier ) ) ).setName("net-decl1")#.setDebug()
        netDecl2Arg = ( "trireg" +
            Optional( chargeStrength ) +
            Optional( expandRange ) +
            Optional( delay ) +
            Group( delimitedList( ~inputOutput + identifier ) ) )
        netDecl3Arg = ( nettype + 
            Optional( driveStrength ) +
            Optional("signed") + 
            Optional( expandRange ) +
            Optional( delay ) +
            Group( delimitedList( assgnmt ) ) )
        netDecl1 = Group(netDecl1Arg + semi)
        netDecl2 = Group(netDecl2Arg + semi)
        netDecl3 = Group(netDecl3Arg + semi)

        functionDecl = Group(
            "function" + Optional( range | "integer" | "real" ) + identifier + 
            Optional( "(" + Group( Optional( delimitedList( 
                Group(oneOf("input output") + 
                Optional( range ) + identifier )
            ) ) ) + ")" 
            ).setName("func-port") + 
            semi + Group( OneOrMore( tfDecl ) ) +
            Group( ZeroOrMore( stmt ) ) +
            "endfunction"
            ).setName("function-decl")#.setDebug()

        gateType = oneOf("and  nand  or  nor xor  xnor buf  bufif0 bufif1 "
                         "not  notif0 notif1  pulldown pullup nmos  rnmos "
                         "pmos rpmos cmos rcmos   tran rtran  tranif0  "
                         "rtranif0  tranif1 rtranif1"  )
        gateInstance = Optional( Group( identifier + Optional( range ) ) ) + \
                        "(" + Group( delimitedList( expr ) ) + ")"
        gateDecl = Group( gateType +
            Optional( driveStrength ) +
            Optional( delay ) +
            delimitedList( gateInstance) +
            semi )

        udpInstance = Group( Group( identifier + Optional(range | subscrRef) ) +
            "(" + Group( delimitedList( expr ) ) + ")" )
        udpInstantiation = Group( identifier -
            Optional( driveStrength ) +
            Optional( delay ) +
            delimitedList( udpInstance ) +
            semi ).setName("udpInstantiation")#.setParseAction(dumpTokens).setDebug()

        parameterValueAssign = (expr | empty).setName("module-anonparam-assign")
        namedParamValueAssign = Group( "." + identifier + "(" + expr + ")" ).setName("module-namedparam-assign")#.setDebug()
        parameterValueAssignment = Group( Literal("#") + "(" + Group( delimitedList( namedParamValueAssign ) | delimitedList( parameterValueAssign ) ).setName("module-param-assign-ctn") + ")" ).setName("module-param-assign")#.setDebug()
        namedPortConnection = Group( "." + identifier + "(" + expr + ")" )
        modulePortConnection = expr | empty
        #~ moduleInstance = Group( Group ( identifier + Optional(range) ) +
            #~ ( delimitedList( modulePortConnection ) |
              #~ delimitedList( namedPortConnection ) ) )
        inst_args = Group( "(" + (delimitedList( modulePortConnection ) |
                    delimitedList( namedPortConnection )) + ")").setName("inst_args")#.setDebug()
        moduleInstance = Group( Group ( identifier + Optional(range) ) + inst_args )

        moduleInstantiation = Group( identifier("moduleInstanceType").setParseAction(parseSubmod) +
            Optional( parameterValueAssignment ) +
            delimitedList( moduleInstance ).setName("moduleInstanceList") +
            semi ).setName("moduleInstantiation")#.setParseAction(dumpTokens)#.setDebug()

        parameterOverride = Group( "defparam" + delimitedList( paramAssgnmt ) + semi )
        task = Group( "task" + identifier + semi +
            ZeroOrMore( tfDecl ) +
            stmtOrNull +
            "endtask" )

        specparamDecl = Group( "specparam" + delimitedList( paramAssgnmt ) + semi )

        pathDescr1 = Group( "(" + subscrIdentifier + "=>" + subscrIdentifier + ")" )
        pathDescr2 = Group( "(" + Group( delimitedList( subscrIdentifier ) ) + "*>" +
                                  Group( delimitedList( subscrIdentifier ) ) + ")" )
        pathDescr3 = Group( "(" + Group( delimitedList( subscrIdentifier ) ) + "=>" +
                                  Group( delimitedList( subscrIdentifier ) ) + ")" )
        pathDelayValue = Group( ( "(" + Group( delimitedList( mintypmaxExpr | expr ) ) + ")" ) |
                                 mintypmaxExpr |
                                 expr )
        pathDecl = Group( ( pathDescr1 | pathDescr2 | pathDescr3 ) + "=" + pathDelayValue + semi ).setName("pathDecl")

        portConditionExpr = Forward()
        portConditionTerm = Optional(unop) + subscrIdentifier
        portConditionExpr << portConditionTerm + Optional( binop + portConditionExpr )
        polarityOp = oneOf("+ -")
        levelSensitivePathDecl1 = Group(
            if_ + Group("(" + portConditionExpr + ")") +
            subscrIdentifier + Optional( polarityOp ) + "=>" + subscrIdentifier + "=" +
            pathDelayValue +
            semi )
        levelSensitivePathDecl2 = Group(
            if_ + Group("(" + portConditionExpr + ")") +
            lpar + Group( delimitedList( subscrIdentifier ) ) + Optional( polarityOp ) + "*>" +
                Group( delimitedList( subscrIdentifier ) ) + rpar + "=" +
            pathDelayValue +
            semi )
        levelSensitivePathDecl = levelSensitivePathDecl1 | levelSensitivePathDecl2

        edgeIdentifier = posedge | negedge
        edgeSensitivePathDecl1 = Group(
            Optional( if_ + Group("(" + expr + ")") ) +
            lpar + Optional( edgeIdentifier ) +
            subscrIdentifier + "=>" +
            lpar + subscrIdentifier + Optional( polarityOp ) + ":" + expr + rpar + rpar +
            "=" +
            pathDelayValue +
            semi )
        edgeSensitivePathDecl2 = Group(
            Optional( if_ + Group("(" + expr + ")") ) +
            lpar + Optional( edgeIdentifier ) +
            subscrIdentifier + "*>" +
            lpar + delimitedList( subscrIdentifier ) + Optional( polarityOp ) + ":" + expr + rpar + rpar +
            "=" +
            pathDelayValue +
            semi )
        edgeSensitivePathDecl = edgeSensitivePathDecl1 | edgeSensitivePathDecl2

        edgeDescr = oneOf("01 10 0x x1 1x x0").setName("edgeDescr")

        timCheckEventControl = Group( posedge | negedge | (edge + "[" + delimitedList( edgeDescr ) + "]" ))
        timCheckCond = Forward()
        timCondBinop = oneOf("== === != !==")
        timCheckCondTerm = ( expr + timCondBinop + scalarConst ) | ( Optional("~") + expr )
        timCheckCond << ( ( "(" + timCheckCond + ")" ) | timCheckCondTerm )
        timCheckEvent = Group( Optional( timCheckEventControl ) +
                                subscrIdentifier +
                                Optional( "&&&" + timCheckCond ) )
        timCheckLimit = expr
        controlledTimingCheckEvent = Group( timCheckEventControl + subscrIdentifier +
                                            Optional( "&&&" + timCheckCond ) )
        notifyRegister = identifier

        systemTimingCheck1 = Group( "$setup" +
            lpar + timCheckEvent + "," + timCheckEvent + "," + timCheckLimit +
            Optional( "," + notifyRegister ) + rpar +
            semi )
        systemTimingCheck2 = Group( "$hold" +
            lpar + timCheckEvent + "," + timCheckEvent + "," + timCheckLimit +
            Optional( "," + notifyRegister ) + rpar +
            semi )
        systemTimingCheck3 = Group( "$period" +
            lpar + controlledTimingCheckEvent + "," + timCheckLimit +
            Optional( "," + notifyRegister ) + rpar +
            semi )
        systemTimingCheck4 = Group( "$width" +
            lpar + controlledTimingCheckEvent + "," + timCheckLimit +
            Optional( "," + expr + "," + notifyRegister ) + rpar +
            semi )
        systemTimingCheck5 = Group( "$skew" +
            lpar + timCheckEvent + "," + timCheckEvent + "," + timCheckLimit +
            Optional( "," + notifyRegister ) + rpar +
            semi )
        systemTimingCheck6 = Group( "$recovery" +
            lpar + controlledTimingCheckEvent + "," + timCheckEvent + "," + timCheckLimit +
            Optional( "," + notifyRegister ) + rpar +
            semi )
        systemTimingCheck7 = Group( "$setuphold" +
            lpar + timCheckEvent + "," + timCheckEvent + "," + timCheckLimit + "," + timCheckLimit +
            Optional( "," + notifyRegister ) + rpar +
            semi )
        systemTimingCheck = (FollowedBy('$') + ( systemTimingCheck1 | systemTimingCheck2 | systemTimingCheck3 |
            systemTimingCheck4 | systemTimingCheck5 | systemTimingCheck6 | systemTimingCheck7 )).setName("systemTimingCheck")
        sdpd = if_ + Group("(" + expr + ")") + \
            ( pathDescr1 | pathDescr2 ) + "=" + pathDelayValue + semi

        specifyItem = ~Keyword("endspecify") +(
            specparamDecl |
            pathDecl |
            levelSensitivePathDecl |
            edgeSensitivePathDecl |
            systemTimingCheck |
            sdpd
            )
        """
        x::= <specparam_declaration>
        x||= <path_declaration>
        x||= <level_sensitive_path_declaration>
        x||= <edge_sensitive_path_declaration>
        x||= <system_timing_check>
        x||= <sdpd>
        """
        specifyBlock = Group( "specify" + ZeroOrMore( specifyItem ) + "endspecify" )

        generateVariance = Group( genvar + identifier + semi ).setName("genvar")#.setDebug()

        generateItem = Forward().setName("generateItem")#.setDebug()
        generateItemOrNull = generateItem | semi

        generateBeginEnd = ( begin + Group( ZeroOrMore( ~end + generateItem ) ) + end ).setName("gen-begin-end")#.setDebug()

        generateLabeledBeginEnd = ( begin + ":" + identifier + ZeroOrMore( blockDecl ) + ZeroOrMore( ~end + generateItem ) + end ).setName("gen-begin:label-end")#.setDebug()

        generateCaseItem = ( delimitedList( expr ) + ":" + generateItemOrNull ) | \
                 ( default + Optional(":") + generateItemOrNull )

        generateItem << ~endgenerate + (
                generateBeginEnd |
                ( if_ + Group("(" + expr + ")") + generateItemOrNull + Optional( else_ + generateItemOrNull ) ).setName("generate-if") |
                ( case + "(" + expr + ")" + OneOrMore( generateCaseItem ) + endcase ).setName("generate-case") |
                (forHdr + generateLabeledBeginEnd ).setName("generate-for") | 
                continuousAssign |
                initialStmt |
                alwaysStmt |
                gateDecl |
                generateLabeledBeginEnd |
                # these have to be at the end - they start with identifiers
                moduleInstantiation |
                udpInstantiation
            )

        generateBlock = Group( generate + OneOrMore( generateItem ) + endgenerate ).setName("generate-blk")

        moduleItem = ~Keyword("endmodule") + (
            parameterDecl |
            localparamDecl |
            inputDecl |
            outputDecl |
            inoutDecl |
            regDecl |
            netDecl3 |
            netDecl1 |
            netDecl2 |
            timeDecl |
            integerDecl |
            realDecl |
            eventDecl |
            gateDecl |
            parameterOverride |
            continuousAssign |
            specifyBlock |
            initialStmt |
            alwaysStmt |
            task |
            functionDecl |
            generateVariance |
            generateBlock |
            # these have to be at the end - they start with identifiers
            moduleInstantiation |
            udpInstantiation
            )
        """  All possible moduleItems, from Verilog grammar spec
        x::= <parameter_declaration>
        x||= <input_declaration>
        x||= <output_declaration>
        x||= <inout_declaration>
        ?||= <net_declaration>  (spec does not seem consistent for this item)
        x||= <reg_declaration>
        x||= <time_declaration>
        x||= <integer_declaration>
        x||= <real_declaration>
        x||= <event_declaration>
        x||= <gate_declaration>
        x||= <UDP_instantiation>
        x||= <module_instantiation>
        x||= <parameter_override>
        x||= <continuous_assign>
        x||= <specify_block>
        x||= <initial_statement>
        x||= <always_statement>
        x||= <task>
        x||= <function>
        """
        portRef = subscrIdentifier
        portExpr = portRef | Group( "{" + delimitedList( portRef ) + "}" )
        port = portExpr | Group( ( "." + identifier + "(" + portExpr + ")" ) )
        moduleHdrPort = Group(
            inputOutput + Optional( nettype | Keyword("reg") ) + 
            Optional("signed") + 
            Optional( expandRange ) +
            ( ~inputOutput + identifier )
        ).setName("modulePort")#.setDebug()

        moduleHdr = Group ( oneOf("module macromodule") + identifier("moduleName").setParseAction(parseModule) +
                 Optional( "(" + Group( Optional( delimitedList( 
                                    moduleHdrPort |
                                    port ) ) ).setName("portList") + 
                            ")" ) + semi )("moduleHdr")#.setDebug()

        module = Group(  moduleHdr +
                 Group( ZeroOrMore( moduleItem ) ).setResultsName("moduleItem") +
                 "endmodule" ).setName("module")#.setDebug()

        udpDecl = outputDecl | inputDecl | regDecl
        #~ udpInitVal = oneOf("1'b0 1'b1 1'bx 1'bX 1'B0 1'B1 1'Bx 1'BX 1 0 x X")
        udpInitVal = (Regex("1'[bB][01xX]") | Regex("[01xX]")).setName("udpInitVal")
        udpInitialStmt = Group( "initial" +
            identifier + "=" + udpInitVal + semi ).setName("udpInitialStmt")

        levelSymbol = oneOf("0   1   x   X   ?   b   B")
        levelInputList = Group( OneOrMore( levelSymbol ).setName("levelInpList") )
        outputSymbol = oneOf("0   1   x   X")
        combEntry = Group( levelInputList + ":" + outputSymbol + semi )
        edgeSymbol = oneOf("r   R   f   F   p   P   n   N   *")
        edge = Group( "(" + levelSymbol + levelSymbol + ")" ) | \
               Group( edgeSymbol )
        edgeInputList = Group( ZeroOrMore( levelSymbol ) + edge + ZeroOrMore( levelSymbol ) )
        inputList = levelInputList | edgeInputList
        seqEntry = Group( inputList + ":" + levelSymbol + ":" + ( outputSymbol | "-" ) + semi ).setName("seqEntry")
        udpTableDefn = Group( "table" +
            OneOrMore( combEntry | seqEntry ) +
            "endtable" ).setName("table")

        """
        <UDP>
        ::= primitive <name_of_UDP> ( <name_of_variable> <,<name_of_variable>>* ) ;
                <UDP_declaration>+
                <UDP_initial_statement>?
                <table_definition>
                endprimitive
        """
        udp = Group( "primitive" + identifier +
            "(" + Group( delimitedList( identifier ) ) + ")" + semi +
            OneOrMore( udpDecl ) +
            Optional( udpInitialStmt ) +
            udpTableDefn +
            "endprimitive" )

        verilogbnf = OneOrMore( module | udp ) + StringEnd()

        verilogbnf.ignore( cppStyleComment )
        verilogbnf.ignore( compilerDirective )

    return verilogbnf


def parse( strng ):
    global module_hier
    module_hier = dict()
    tokens = []
    try:
        tokens = Verilog_BNF().parseString( strng )
    except ParseException as err:
        print (err.line)
        print (" "*(err.column-1) + "^")
        print (err)
    # return tokens
    return module_hier



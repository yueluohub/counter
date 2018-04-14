#!/usr/bin/python3

import argparse
import os
import re

parser = argparse.ArgumentParser(description='Build up starting point for block level sim')
parser.add_argument('--block_name', '-blk', type=str, dest='blkname', help='Block name')
parser.add_argument('--folder_name', '-folder', type=str, dest='foldername', help='Folder name where block RTL is located')
parser.add_argument('--sim_folder', '-sim_dir', type=str, default='', dest='simdir', help='Simulation directory')
# parser.add_argument('--project_name', '-prj', type=str, dest='prjname', help='Project name')
args = parser.parse_args()
if args.simdir.__len__() < 1:
    args.simdir = os.environ.get('SIM_DIR')
    if args.simdir is None:
        print ("$SIM_DIR does not specified. Please use -sim_dir to specify it.")
        exit(-1)
blksimdir = '{0}/{1}'.format(args.simdir, args.blkname)
if not os.path.isdir(blksimdir):
    os.system('mkdir {0}'.format(blksimdir))

os.chdir(blksimdir)

runpl = open('run.pl', 'w')
wrStr = '''#!/usr/bin/perl
use Getopt::Long;
use Cwd;

my $tvname;
my $sim = 1;
GetOptions (
  "tv|tvname=s" => \$tvname, # test vector name
  "sim!" => \$sim,
);
my $TV_DIR= "$ENV{1}/{0}";

my $cmd = "ncvlog -64 -linedebug -define NO_ASYNC_2FLOPS -sv -message -f {0}.vf";
print("$cmd\\n");
my $vlogret = system($cmd);
die "Ncvlog failed!" if ($vlogret);

$param = '';
$cmd = "ncelab -64 -timescale 1ns/1ps -access +rwc -loadpli1 debpli:novas_pli_boot $param tb_{0}";
my $elabret = system($cmd);
die "Elab failed!" if ($elabret);

print("$cmd\\n");
$cmd = "vericom -64 -sv -message -f {0}.vf";
my $verdiret = system($cmd);
if ($sim) {
  if (length($tvname) > 0) {2}
    $cmd = "ncsim -64 tb_{0} -input run.tcl +tv=\\"$path\\"";
  {3} else {2}
    $cmd = "ncsim -64 tb_{0} -input run.tcl";
  {3}
  print("$cmd\\n");
  my $simret = system($cmd);
  print ("$simret\\n");
}
'''.format(args.blkname, '{TV_DIR}', '{', '}')

runpl.write(wrStr)
runpl.close()

runtcl = open('run.tcl', 'w')
wrStr = '''
call fsdbDumpfile "tb_{0}.fsdb"
call fsdbDumpvars tb_{0} "+mda"
run
exit
'''.format(args.blkname)
runtcl.write(wrStr)
runtcl.close()

def checkparam(lineStr):
    reRslt = re.search(r'\s*\b(parameter\b\s+.*)', lineStr)
    if reRslt:
        reStr = re.sub(r',\s*$', '', reRslt.group(1))
        reStr += ';'
        return reStr
    else:
        return None

def checkport(lineStr):
    reRslt = re.search(r'\b(input|output)\b\s+(.*)', lineStr)
    if reRslt:
        reStr = re.sub(r',\s*$', '', reRslt.group(2))
        reStr = re.sub(r'wire', 'logic', reStr)
        reStr += '; // {0}'.format(reRslt.group(1))
        return reStr
    else:
        return None

rtlname = '{0}/{1}/{2}.sv'.format(os.environ['RTL_DIR'], args.foldername, args.blkname);
print (rtlname);
paramList = []
portList = []
with open(rtlname, 'r') as blksv:
    for lineStr in blksv:
        lineStr.rstrip()
        paramStr = checkparam(lineStr)
        if paramStr:
            paramList.append(paramStr)
        portStr = checkport(lineStr)
        if portStr:
            portList.append(portStr)

portStr = ''
for port in portList:
    portStr += '{0}\n'.format(port)

paramMapStr = ''
if paramList.__len__() > 0:
    paramMapStr = '#('
paramStr = ''
print (paramList)
for idx, param in enumerate(paramList):
    print('{0}: {1}'.format(idx, param))
    paramStr += '{0}\n'.format(param)
    paramName = re.search('parameter\s+(\S+)\s*=', param)
    paramName = paramName.group(1)
    if (idx == paramList.__len__() - 1):
        paramMapStr += '.{0} ( {0} )\n'.format(paramName)
    else:
        paramMapStr += '.{0} ( {0} ),\n'.format(paramName)
if paramList.__len__() > 0:
  paramMapStr += ') '

print (portStr)
print (paramStr)

tbblk = open('tb_{0}.sv'.format(args.blkname), 'w')

wrStr = '''
module tb_{0} ();
{2}

{3}

initial begin
  i_rst_n = '0;
  #14;
  i_rst_n = '1;
end
initial begin
  i_clk = '0;
  forever begin
    #5;
    i_clk = ~ i_clk;
  end
end

// TODO: add your own setup
{0} {PARAMMAP} u_dut (
  .*
);

endmodule
'''.format(args.blkname, args.foldername, paramStr, portStr, PARAMMAP=paramMapStr)

tbblk.write(wrStr)
tbblk.close()

vf = open('{0}.vf'.format(args.blkname), 'w')
wrStr = '''
+incdir+{0}
+incdir+{1}
{1}/{2}/{3}.sv
{0}/{3}/tb_{3}.sv
'''.format('$SIM_DIR', '$RTL_DIR', args.foldername, args.blkname)
vf.write(wrStr)
vf.close()


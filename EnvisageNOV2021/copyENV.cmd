set inDir=v:\Env10

goto Data

mkdir 10x10
cd 10x10
mkdir Doc
cd Doc

:10x10Doc
copy %indir%\10x10\Doc\Bilat.xlsx .
copy %indir%\10x10\Doc\Bilat.xlsx .
copy %indir%\10x10\Doc\Cost.xlsx .
copy %indir%\10x10\Doc\factp.xlsx .
copy %indir%\10x10\Doc\gdppop.xlsx .
copy %indir%\10x10\Doc\Inv.xlsx .
copy %indir%\10x10\Doc\Output.xlsx .
copy %indir%\10x10\Doc\sam.xlsx .
copy %indir%\10x10\Doc\savinv.xlsx .
copy %indir%\10x10\Doc\Trade.xlsx .
copy %indir%\10x10\Doc\va.xlsx .
copy %indir%\10x10\Doc\YDecomp.xlsx .

:10x10
cd ..
copy %indir%\10x10\10x10BoP.gdx       .
copy %indir%\10x10\10x10Dat.gdx       .
copy %indir%\10x10\10x10emiss.gdx     .
copy %indir%\10x10\10x10InvTgt.gdx    .
copy %indir%\10x10\10x10MRIO.gdx      .
copy %indir%\10x10\10x10nco2.gdx      .
copy %indir%\10x10\10x10Opt.gms       .
copy %indir%\10x10\10x10Par.gdx       .
copy %indir%\10x10\10x10Prm.gdx       .
copy %indir%\10x10\10x10Prm.gms       .
copy %indir%\10x10\10x10Sat.gdx       .
copy %indir%\10x10\10x10Scn.gdx       .
copy %indir%\10x10\10x10Sets.gms      .
copy %indir%\10x10\10x10Tab.gms       .
copy %indir%\10x10\10x10vole.gdx      .
copy %indir%\10x10\BaUShk.gms         .
copy %indir%\10x10\CompSAM.xlsx       .
copy %indir%\10x10\compShk.gms        .
copy %indir%\10x10\COVIDShk.gms       .
copy %indir%\10x10\DynTarShk.gms      .
copy %indir%\10x10\EqnCount.xlsx      .
copy %indir%\10x10\iceberg.gms        .
copy %indir%\10x10\icebergShk.gms     .
copy %indir%\10x10\nCovShk.gms        .
copy %indir%\10x10\runAll.cmd         .
copy %indir%\10x10\runBaU.gms         .
copy %indir%\10x10\runDynTar.gms      .
copy %indir%\10x10\runnoShk.gms       .
copy %indir%\10x10\runSim.cmd         .
copy %indir%\10x10\runSim.gms         .
copy %indir%\10x10\runSimdr.cmd       .
copy %indir%\10x10\runSimr.cmd        .
copy %indir%\10x10\runtab.cmd         .
copy %indir%\10x10\runTar.gms         .
copy %indir%\10x10\tarShk.gms         .
copy %indir%\10x10\TFPShk.gms         .
cd ..

:ANX1

mkdir ANX1
cd ANX1
mkdir Doc
cd Doc

copy %indir%\ANX1\Doc\depl.xlsx       .
copy %indir%\ANX1\Doc\gdppop.xlsx     .
copy %indir%\ANX1\Doc\nrg.xlsx        .
copy %indir%\ANX1\Doc\Output.xlsx     .
copy %indir%\ANX1\Doc\Trade.xlsx      .
copy %indir%\ANX1\Doc\va.xlsx         .

cd ..

copy %indir%\ANX1\anx1BoP.gdx               .
copy %indir%\ANX1\anx1Dat.gdx               .
copy %indir%\ANX1\anx1Depl.gdx              .
copy %indir%\ANX1\ANX1DynPrm.gdx            .
copy %indir%\ANX1\anx1emiss.gdx             .
copy %indir%\ANX1\anx1InvTgt.gdx            .
copy %indir%\ANX1\ANX1LabNotes.xlsx         .
copy %indir%\ANX1\ANX1nco2.gdx              .
copy %indir%\ANX1\ANX1Opt.gms               .
copy %indir%\ANX1\anx1Par.gdx               .
copy %indir%\ANX1\anx1Prm.gdx               .
copy %indir%\ANX1\ANX1Prm.gms               .
copy %indir%\ANX1\anx1Sat.gdx               .
copy %indir%\ANX1\anx1Scn.gdx               .
copy %indir%\ANX1\anx1Sets.gms              .
copy %indir%\ANX1\Anx1Tab.gms               .
copy %indir%\ANX1\anx1vole.gdx              .
copy %indir%\ANX1\anx1Wages.gdx             .
copy %indir%\ANX1\BaUShk.gms                .
copy %indir%\ANX1\calDyn.gms                .
copy %indir%\ANX1\CompSAM.xlsx              .
copy %indir%\ANX1\CompShk.gms               .
copy %indir%\ANX1\ctaxshk.gms               .
copy %indir%\ANX1\EqnCount.xlsx             .
copy %indir%\ANX1\extractGDX.gms            .
copy %indir%\ANX1\noshkShk.gms              .
copy %indir%\ANX1\runAll.cmd                .
copy %indir%\ANX1\runBaU.gms                .
copy %indir%\ANX1\runCtax.gms               .
copy %indir%\ANX1\runnoShk.gms              .
copy %indir%\ANX1\runSim.cmd                .
copy %indir%\ANX1\runSim.gms                .
copy %indir%\ANX1\runtab.cmd                .

cd ..

:Data

mkDir Data
cd Data
mkdir AlterTax
cd AlterTax

copy %inDir%\Data\AlterTax\AlterTaxPrm.gms  .
copy %inDir%\Data\AlterTax\conopt.opt       .
copy %inDir%\Data\AlterTax\conopt4.opt      .

cd ..

mkdir Filter
cd Filter

copy %inDir%\Data\Filter\filter.gms          .
copy %inDir%\Data\Filter\itrlog.gms          .
copy %inDir%\Data\Filter\remTinyValues.gms   .
copy %inDir%\Data\Filter\title.gms           .

cd ..

mkdir GTAPModel
cd GTAPModel

copy %inDir%\Data\GTAPModel\cal.gms             .
copy %inDir%\Data\GTAPModel\emiCSV.gms          .
copy %inDir%\Data\GTAPModel\getData.gms         .
copy %inDir%\Data\GTAPModel\iterloop.gms        .
copy %inDir%\Data\GTAPModel\model.gms           .
copy %inDir%\Data\GTAPModel\mvar.gms            .
copy %inDir%\Data\GTAPModel\postsim.gms         .
copy %inDir%\Data\GTAPModel\saveData.gms        .
copy %inDir%\Data\GTAPModel\solve.gms           .

cd ..

copy %inDir%\Data\10x10Alt.gms               .
copy %inDir%\Data\10x10flt.gms               .
copy %inDir%\Data\10x10map.gms               .
copy %inDir%\Data\AggEnvElast.gms            .
copy %inDir%\Data\AggGTAP.gms                .
copy %inDir%\Data\aggNRG.gms                 .
copy %inDir%\Data\aggra.gms                  .
copy %inDir%\Data\aggrav.gms                 .
copy %inDir%\Data\aggrave.gms                .
copy %inDir%\Data\aggSAM.gms                 .
copy %inDir%\Data\altertax.gms               .
copy %inDir%\Data\ANX1Alt.gms                .
copy %inDir%\Data\ANX1BKStp.gms              .
copy %inDir%\Data\ANX1Flt.gms                .
copy %inDir%\Data\ANX1Map.gms                .
copy %inDir%\Data\conopt.opt                 .
copy %inDir%\Data\conopt4.opt                .
copy %inDir%\Data\ConvertLabel.gms           .
copy %inDir%\Data\filter.gms                 .
copy %inDir%\Data\GTAPSets10AF.gms           .
copy %inDir%\Data\GTAPSets10APOWF.gms        .
copy %inDir%\Data\gtapsets9_2F.gms           .
copy %inDir%\Data\GTAPSets9_2PF.gms          .
copy %inDir%\Data\Macro.gms                  .
copy %inDir%\Data\makeAggSets.gms            .
copy %inDir%\Data\makedata.cmd               .
copy %inDir%\Data\makedata.sh                .
copy %inDir%\Data\makeset.gms                .
copy %inDir%\Data\makesetEnv.gms             .
copy %inDir%\Data\nipa.gms                   .
copy %inDir%\Data\saveMap.gms                .
copy %inDir%\Data\SSPSets.gms                .

cd ..

:Doc
mkdir Doc
cd Doc

copy %inDir%\Doc\Env10.pdf                   .
copy %inDir%\Doc\GTAPDatabase.pdf            .
copy %inDir%\ModLog.docx                 .
copy v:\bin\parselst.exe                .

cd ..

:Model
mkdir Model

cd Model

copy %inDir%\Model\cal.gms                  .
copy %inDir%\Model\cdecal.gms               .
copy %inDir%\Model\climdatav10.gms          .
copy %inDir%\Model\closure.gms              .
copy %inDir%\Model\compScen.gms             .
copy %inDir%\Model\CreatePivot.gms          .
copy %inDir%\Model\CreateSAMXLS.gms         .
copy %inDir%\Model\EmbeddedCO2.gms          .
copy %inDir%\Model\EmbeddedCO2Bis.gms       .
copy %inDir%\Model\getData.gms              .
copy %inDir%\Model\init.gms                 .
copy %inDir%\Model\InitScen.gms             .
copy %inDir%\Model\InitVar.gms              .
copy %inDir%\Model\InitVint.gms             .
copy %inDir%\Model\iterloop.gms             .
copy %inDir%\Model\makCSV.gms               .
copy %inDir%\Model\makTab.gms               .
copy %inDir%\Model\MiscDat.gms              .
copy %inDir%\Model\model.gms                .
copy %inDir%\Model\postsim.gms              .
copy %inDir%\Model\recal.gms                .
copy %inDir%\Model\recalnnn.gms             .
copy %inDir%\Model\recalnnt.gms             .
copy %inDir%\Model\recalnrg.gms             .
copy %inDir%\Model\recalnrgACES.gms         .
copy %inDir%\Model\recalnrs.gms             .
copy %inDir%\Model\recalvat.gms             .
copy %inDir%\Model\recalvnn.gms             .
copy %inDir%\Model\recalvnnACES.gms         .
copy %inDir%\Model\recalvnt.gms             .
copy %inDir%\Model\recalxanrg.gms           .
copy %inDir%\Model\recalxanrgACES.gms       .
copy %inDir%\Model\recalxanrgn.gms          .
copy %inDir%\Model\recalxanrgnACES.gms      .
copy %inDir%\Model\sam.gms                  .
copy %inDir%\Model\saveParm.gms             .
copy %inDir%\Model\scale.gms                .
copy %inDir%\Model\setupPivot.gms           .
copy %inDir%\Model\solve.gms                .
cd ..

:SatAcct

mkdir SatAcct
cd SatAcct

copy %inDir%\SatAcct\EnvLinkElast.gdx           .
copy %inDir%\SatAcct\EnvLinkElast10A.gdx        .
copy %inDir%\SatAcct\EnvLinkElast10APow.gdx     .
copy %inDir%\SatAcct\EnvLinkElast9_2.gdx        .
copy %inDir%\SatAcct\giddLab.gdx                .
copy %inDir%\SatAcct\giddProj.gdx               .
copy %inDir%\SatAcct\rystadGTAP2014.gdx         .
copy %inDir%\SatAcct\sspScenV9.gdx              .
copy %inDir%\SatAcct\sspScenV9_2.gdx            .

cd ..

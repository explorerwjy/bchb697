-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 29, 2016 at 05:07 AM
-- Server version: 10.1.13-MariaDB
-- PHP Version: 5.6.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jw1509_ptop`
--
CREATE DATABASE IF NOT EXISTS `jw1509_ptop` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `jw1509_ptop`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `general_view` ()  begin
select HTMLLink(Uniprot_entry_ID,'p'),protein_name,HTMLLink(HGNC_id,'g'),Approved_Symbol,Chromosome_location
from vw_ptop;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_link` (IN `protein_name` VARCHAR(45))  begin
select 
a.protein_name,
a.Uniprot_entry_id,
HTMLLink(a.Uniprot_entry_id, a.Uniprot_URL) as UniprotHtmlLink,
b.HGNC_id,
HTMLLink(b.HGNC_id, b.HGNC_URL) as HGNCHtmlLink
from protein a
join gene b
on a.hgnc_id = b.hgnc_id
where a.protein_name = protein_name;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `look_do` ()  begin

select 
a.number_of_protein_with_do,a.number_of_protein_without_do,
b.number_of_mim_with_do,b.number_of_mim_without_do
from vw_stat_1 a join vw_stat_2 b on a.join_label = b.join_label;

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `look_mim` ()  begin
select 
HTMLLink(a.MIM_phenotype_id, 'm') as MIM_phenotype_id,
ifnull(GROUP_CONCAT(distinct a.Unipro_disease_name SEPARATOR ';'),'none') as Uniprot_disease_names,
ifnull(GROUP_CONCAT(distinct HTMLLink(b.Uniprot_entry_id,'p') SEPARATOR ';'),'none') as related_proteins,
count(b.Uniprot_entry_id) as number_of_related_protein
from uniprotomimrelationship a
left outer join protein b
on a.Uniprot_entry_id = b.Uniprot_entry_id
group by a.MIM_phenotype_id
order by number_of_related_protein desc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `protein_longer_than` (IN `length_low` INT, IN `length_high` INT, IN `mass_low` INT, IN `mass_high` INT)  begin
select HTMLLink(Uniprot_entry_ID,'p') as Uniprot_entry_ID
, protein_name, Sequence_Length, mass
from protein
where 
Sequence_Length>length_low and 
Sequence_Length<length_high and
mass > mass_low and
mass < mass_high
order by Sequence_Length desc;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `protein_with_many_name` ()  BEGIN
     SELECT Uniprot_entry_ID,Protein_Name,altername,MIMphnotypes,DO_ids,HGNC_id
     FROM vw_protein
     WHERE instr(altername,',') > 4;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `protein_with_many_names` (IN `num_of_names` INT)  BEGIN
     SELECT 
     getSubNum(altername,';') as `#altnames`,
     HTMLLink(Uniprot_entry_id, "p") as Uniprot_entry_id,
     Protein_Name,altername,
     HTMLLink(HGNC_id, "g") as HGNC_id
     FROM vw_ptop
     WHERE getSubNum(altername,';') >= num_of_names
     order by `#altnames` desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_disease_name` (IN `disease_name` VARCHAR(45))  BEGIN
     SELECT 
     * from search_disease_name
     WHERE instr(Uniprot_Disease_Name,disease_name) > 0;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getSubNum` (`str` VARCHAR(1000), `sub_str` VARCHAR(250)) RETURNS INT(11) BEGIN
declare num int(11);
select (char_length(str) - char_length(replace(str,sub_str,''))) / (char_length(sub_str)) into num;
RETURN num;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `HTMLLink` (`id` VARCHAR(10), `tpye` VARCHAR(1)) RETURNS VARCHAR(300) CHARSET utf8 begin
	declare Link varchar(300);
    declare URL1 varchar(100);
    declare URL2 varchar(100);	
    declare URL3 varchar(100);
	set URL1 = "http://www.uniprot.org/uniprot/";
	set URL2 = "http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=";
    set URL3 = "http://www.omim.org/entry/";
    if tpye = 'p' then
		select concat('<a href=', '"', URL1,id,'" target="_blank"><b>', id, '</b>') into Link;
    elseif tpye = 'g' then
		select concat('<a href=', '"', URL2,id,'" target="_blank"><b>', id, '</b>') into Link;
    elseif tpye = 'm' then
		select concat('<a href=', '"', URL3,id,'" target="_blank"><b>', id, '</b>') into Link;
	end if;
	return Link;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dieasename`
--

CREATE TABLE `dieasename` (
  `Uniprot_Disease_name` varchar(200) NOT NULL COMMENT 'Full name of the uniprot diease',
  `Diease_short_name` varchar(45) DEFAULT NULL COMMENT 'short name of the full name'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dieasename`
--

INSERT INTO `dieasename` (`Uniprot_Disease_name`, `Diease_short_name`) VALUES
('Achondroplasia', 'ACH'),
('ACTH-independent macronodular adrenal hyperplasia 1', 'AIMAH1'),
('Albinism, oculocutaneous, 1A', 'OCA1A'),
('Albinism, oculocutaneous, 1B', 'OCA1B'),
('Alzheimer disease 1', 'AD1'),
('Amyloidosis 5', 'AMYL5'),
('Amyloidosis 6', 'AMYL6'),
('Amyloidosis 8', 'AMYL8'),
('Amyloidosis, primary localized cutaneous, 1', 'PLCA1'),
('Amyloidosis, primary localized cutaneous, 2', 'PLCA2'),
('Amyloidosis, transthyretin-related', 'AMYL-TTR'),
('Bannayan-Riley-Ruvalcaba syndrome', 'BRRS'),
('Breast cancer', 'BC'),
('Carpal tunnel syndrome 1', 'CTS1'),
('Cerebral amyloid angiopathy, APP-related', 'CAA-APP'),
('Cerebro-oculo-facio-skeletal syndrome 1', 'COFS1'),
('Chronic infantile neurologic cutaneous and articular syndrome', 'CINCA'),
('Cockayne syndrome A', 'CSA'),
('Cockayne syndrome B', 'CSB'),
('Colorectal cancer', 'CRC'),
('Congenital afibrinogenemia', 'CAFBN'),
('Corneal dystrophy, epithelial basement membrane', 'EBMD'),
('Corneal dystrophy, gelatinous drop-like', 'GDLD'),
('Corneal dystrophy, Groenouw type 1', 'CDGG1'),
('Corneal dystrophy, lattice type 1', 'CDL1'),
('Corneal dystrophy, Thiel-Behnke type', 'CDTB'),
('Cowden syndrome 1', 'CWS1'),
('Cowden syndrome 2', 'CWS2'),
('Cowden syndrome 4', 'CWS4'),
('Creutzfeldt-Jakob disease', 'CJD'),
('Crouzon syndrome with acanthosis nigricans', 'CAN'),
('Cutaneous telangiectasia and cancer syndrome, familial', 'FCTCS'),
('De Sanctis-Cacchione syndrome', 'DSC'),
('Diarrhea 5, with tufting enteropathy, congenital', 'DIAR5'),
('Dysfibrinogenemia, congenital', 'DYSFIBRIN'),
('Endometrial cancer', 'ENDMC'),
('Esophageal cancer', 'ESCR'),
('Familial adenomatous polyposis', 'FAP'),
('Familial cold autoinflammatory syndrome 1', 'FCAS1'),
('Familial hibernian fever', 'FHF'),
('Familial Mediterranean fever, autosomal dominant', 'ADFMF'),
('Familial Mediterranean fever, autosomal recessive', 'ARFMF'),
('Fanconi anemia complementation group Q', 'FANCQ'),
('Fatal familial insomnia', 'FFI'),
('Gerstmann-Straussler disease', 'GSD'),
('GNAS hyperfunction', 'GNASHYP'),
('Hereditary desmoid disease', 'HDD'),
('Hereditary non-polyposis colorectal cancer 1', 'HNPCC1'),
('Hereditary non-polyposis colorectal cancer 2', 'HNPCC2'),
('Hereditary non-polyposis colorectal cancer 4', 'HNPCC4'),
('Hereditary non-polyposis colorectal cancer 5', 'HNPCC5'),
('Hereditary non-polyposis colorectal cancer 6', 'HNPCC6'),
('Hereditary non-polyposis colorectal cancer 7', 'HNPCC7'),
('Hereditary non-polyposis colorectal cancer 8', 'HNPCC8'),
('High density lipoprotein deficiency 1', 'HDLD1'),
('High density lipoprotein deficiency 2', 'HDLD2'),
('Hypercatabolic hypoproteinemia', 'HYCATHYP'),
('Hyperthyroxinemia, dystransthyretinemic', 'DTTRH'),
('Intestinal carcinoid tumor', 'ICT'),
('Lhermitte-Duclos disease', 'LDD'),
('Li-Fraumeni syndrome', 'LFS1'),
('Loeys-Dietz syndrome 2', 'LDS2'),
('Macular degeneration, age-related, 11', 'ARMD11'),
('Macular degeneration, age-related, 5', 'ARMD5'),
('Medulloblastoma', 'MDB'),
('Mismatch repair cancer syndrome', 'MMRCS'),
('Muckle-Wells syndrome', 'MWS'),
('Muir-Torre syndrome', 'MRTES'),
('Multiple myeloma', 'MM'),
('Multiple sclerosis 5', 'MS5'),
('Osteoporosis', 'OSTEOP'),
('Ovarian cancer', 'OC'),
('Paraganglioma and gastric stromal sarcoma', 'PGGSS'),
('Paragangliomas 1', 'PGL1'),
('Paragangliomas 4', 'PGL4'),
('Pheochromocytoma', 'PCC'),
('Proteus syndrome', 'PROTEUSS'),
('Pseudohypoparathyroidism 1B', 'PHP1B'),
('Seckel syndrome 1', 'SCKL1'),
('Squamous cell carcinoma of the head and neck', 'HNSCC'),
('Thanatophoric dysplasia 1', 'TD1'),
('Thanatophoric dysplasia 2', 'TD2'),
('UV-sensitive syndrome 2', 'UVSS2'),
('Xeroderma pigmentosum complementation group F', 'XP-F'),
('Xeroderma pigmentosum type F/Cockayne syndrome', 'XPF/CS'),
('XFE progeroid syndrome', 'XFEPS');

-- --------------------------------------------------------

--
-- Table structure for table `do`
--

CREATE TABLE `do` (
  `DO_id` int(11) NOT NULL COMMENT 'Disease Ontology ID',
  `Disease_Name` varchar(100) DEFAULT NULL COMMENT 'Name of the Disease ontology',
  `Definition` varchar(1000) DEFAULT NULL COMMENT 'Definition of Diease',
  `relashion` varchar(200) DEFAULT NULL COMMENT 'relashion of this disease'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table is about Disease Ontology\n';

--
-- Dumping data for table `do`
--

INSERT INTO `do` (`DO_id`, `Disease_Name`, `Definition`, `relashion`) VALUES
(1520, 'colon carcinoma', 'A colon cancer that has_material_basis_in abnormally proliferating cells derives_from epithelial cells.', 'is_a colon cancer'),
(1612, 'breast cancer', '  A thoracic cancer that originates in the mammary gland. ', 'is_a thoracic cancer'),
(2236, 'congenital afibrinogenemia', '', 'is_a inherited blood coagulation disease'),
(2962, 'Cockayne syndrome', 'An autosomal recessive disease that is caused by rare mutations in two DNA excision repair proteins, ERCC-8 and ERCC-6, and characterized by growth failure, impaired development of the nervous system, abnormal sensitivity to sunlight (photosensitivity), and premature aging.', 'is_a autosomal recessive disease'),
(3883, 'Lynch syndrome', 'An autosomal dominant disease that is characterized by \nand has_material_basis_in mutation of mismatch repair genes that increases the risk of many types of cancers.', 'is_a autosomal dominant disease'),
(4480, 'achondroplasia', 'An osteochondrodysplasia that results_in dwarfism which has_material_basis_in abnormal ossification of cartilage in located_in long bone. ', 'is_a osteochondrodysplasia'),
(5520, 'head and neck squamous cell carcinoma', 'A head and neck carcinoma that has_material_basis_in squamous cells that line the moist, mucosal surfaces inside the head and neck.', 'is_a head and neck carcinoma'),
(6457, 'Cowden disease', 'An autosomal dominant disease characterized by multiple noncancerous, tumor-like growths (hamartomas) and an increased risk of certain forms of cancer, especially breast, thyroid and endometrium. It is caused by mutations in the PTEN, SDHB, SDHD and KLLN genes.', 'is_a autosomal dominant disease'),
(9246, 'cerebral amyloid angiopathy', 'An amyloidosis where amyloid protein progressively deposits in cerebral blood vessel walls with subsequent degenerative vascular changes that usually result in spontaneous cerebral hemorrhage, ischemic lesions and progressive dementia.', 'is_a amyloidosis'),
(9256, 'colorectal cancer', 'A large intestine cancer that is located_in the colon and/or located_in the rectum.', 'is_a large intestine cancer'),
(9538, 'multiple myeloma', 'A myeloma that is located_in the plasma cells in bone marrow.', 'is_a myeloma'),
(10652, 'Alzheimer''s disease', 'A tauopathy that results in progressive memory loss, impaired thinking, disorientation, and changes in personality and mood starting and leads in advanced cases to a profound decline in cognitive and physical functioning and is marked histologically by the degeneration of brain neurons especially in the cerebral cortex and by the presence of neurofibrillary tangles and plaques containing beta-amyloid. It is characterized by memory lapses, confusion, emotional instability and progressive loss of mental ability.', 'is_a tauopathy'),
(13482, 'Proteus syndrome', 'None', 'is_a physical disorder'),
(50424, 'familial adenomatous polyposis', 'An autosomal dominant disease that is caused by mutations in the APC gene and involves formation of numerous polyps in the epithelium of the large intestine which are initially benign and later transform into colon cancer.', 'is_a autosomal dominant disease'),
(50427, 'xeroderma pigmentosum', 'An autosomal recessive disease that is characterized by a deficiency in the ability to repair ultraviolet damage that has_material_basis_in autosomal recessive inheritance of DNA repair.', 'is_a autosomal recessive disease'),
(50636, 'familial visceral amyloidosis', '', 'is_a amyloidosis'),
(50637, 'Finnish type amyloidosis', '', 'is_a amyloidosis'),
(50638, 'transthyretin amyloidosis', 'An amyloidosis that is characterized by a loss of sensation in the extremities, cardiomyopathy, nephropathy, vitreous opacities, and CNS amyloidosis resulting from abnormal deposits of amyloid protein in the body''s organs and tissues and has_material_basis_in autosomal dominant inheritance of mutations in the TTR gene.', 'is_a amyloidosis'),
(50773, 'paraganglioma', '', 'is_a neuroendocrine tumor'),
(60447, 'epithelial basement membrane dystrophy', '', 'is_a epithelial and subepithelial dystrophy'),
(216400, 'Cockayne syndrome', 'An autosomal recessive disease that is caused by rare mutations in two DNA excision repair proteins, ERCC-8 and ERCC-6, and characterized by growth failure, impaired development of the nervous system, abnormal sensitivity to sunlight (photosensitivity), and premature aging. ', 'is_a autosomal recessive disease');

-- --------------------------------------------------------

--
-- Table structure for table `gene`
--

CREATE TABLE `gene` (
  `HGNC_id` int(11) NOT NULL COMMENT 'ID of the gene in HGNC database',
  `HGNC_URL` varchar(100) DEFAULT NULL COMMENT 'URL of the gene on HGNC website',
  `Approved_Symbol` varchar(100) DEFAULT NULL COMMENT 'short name of the gene',
  `Approved_Name` varchar(100) DEFAULT NULL COMMENT 'full and primary name of gene',
  `Chromosome_location` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This entity is describe information of\ngene from HGNC.\nPK is HGNC id\n';

--
-- Dumping data for table `gene`
--

INSERT INTO `gene` (`HGNC_id`, `HGNC_URL`, `Approved_Symbol`, `Approved_Name`, `Chromosome_location`) VALUES
(391, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=391', 'AKT1', 'v-akt murine thymoma viral oncogene homolog 1', '14q32.33'),
(583, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=583', 'APC', 'adenomatous polyposis coli', '5q21-q22'),
(600, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=600', 'APOA1', 'apolipoprotein A-I', '11q23-q24'),
(620, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=620', 'APP', 'amyloid beta precursor protein', '21q21.2'),
(882, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=882', 'ATR', 'ATR serine/threonine kinase', '3q23'),
(914, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=914', 'B2M', 'beta-2-microglobulin', '15q21.1'),
(1582, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=1582', 'CCND1', 'cyclin D1', '11q13'),
(2475, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=2475', 'CST3', 'cystatin C', '20p11.2'),
(3436, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=3436', 'ERCC4', 'excision repair cross-complementation group 4', '16p13.3'),
(3438, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=3438', 'ERCC6', 'excision repair cross-complementation group 6', '10q11'),
(3439, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=3439', 'ERCC8', 'excision repair cross-complementation group 8', '5q12.1'),
(3661, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=3661', 'FGA', 'fibrinogen alpha chain', '4q28'),
(3690, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=3690', 'FGFR3', 'fibroblast growth factor receptor 3', '4p16.3'),
(4620, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=4620', 'GSN', 'gelsolin', '9q33'),
(5525, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=5525', 'IGHG1', 'immunoglobulin heavy constant gamma 1 (G1m marker)', '14q32.33'),
(6062, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=6062', 'ING1', 'inhibitor of growth family member 1', '13q34'),
(6119, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=6119', 'IRF4', 'interferon regulatory factor 4', '6p25.3'),
(6740, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=6740', 'LYZ', 'lysozyme', '12q15'),
(6998, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=6998', 'MEFV', 'Mediterranean fever', '16p13.3'),
(7127, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=7127', 'MLH1', 'mutL homolog 1', '3p22.3'),
(7128, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=7128', 'MLH3', 'mutL homolog 3', '14q24.3'),
(7325, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=7325', 'MSH2', 'mutS homolog 2', '2p21'),
(7329, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=7329', 'MSH6', 'mutS homolog 6', '2p16'),
(8507, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=8507', 'OSMR', 'oncostatin M receptor', '5p13.2'),
(8975, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=8975', 'PIK3CA', 'phosphatidylinositol-4;5-bisphosphate 3-kinase catalytic subunit alpha', '3q26.3'),
(9122, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=9122', 'PMS2', 'PMS1 homolog 2; mismatch repair system component', '7p22.1'),
(9449, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=9449', 'PRNP', 'prion protein', '20p13'),
(9588, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=9588', 'PTEN', 'phosphatase and tensin homolog', '10q23'),
(10513, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=10513', 'SAA1', 'serum amyloid A1', '11p15.1'),
(10514, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=10514', 'SAA2', 'serum amyloid A2', '11p15.1-p14'),
(10681, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=10681', 'SDHB', 'succinate dehydrogenase complex iron sulfur subunit B', '1p36.1-p35'),
(10683, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=10683', 'SDHD', 'succinate dehydrogenase complex subunit D', '11q23'),
(11529, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=11529', 'EPCAM', 'epithelial cell adhesion molecule', '2p21'),
(11530, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=11530', 'TACSTD2', 'tumor-associated calcium signal transducer 2', '1p32'),
(11771, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=11771', 'TGFBI', 'transforming growth factor beta induced', '5q31'),
(11773, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=11773', 'TGFBR2', 'transforming growth factor beta receptor II', '3p22'),
(11905, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=11905', 'TNFRSF10B', 'tumor necrosis factor receptor superfamily member 10b', '8p22-p21'),
(11916, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=11916', 'TNFRSF1A', 'tumor necrosis factor receptor superfamily member 1A', '12p13.2'),
(11998, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=11998', 'TP53', 'tumor protein p53', '17p13.1'),
(12405, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=12405', 'TTR', 'transthyretin', '18q12.1'),
(12442, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=12442', 'TYR', 'tyrosinase', '11q14.3'),
(13299, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=13299', 'LGR4', 'leucine-rich repeat containing G protein-coupled receptor 4', '11p14-p13'),
(14587, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=14587', 'ING3', 'inhibitor of growth family member 3', '7q31'),
(16400, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=16400', 'NLRP3', 'NLR family; pyrin domain containing 3', '1q44'),
(18969, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=18969', 'IL31RA', 'interleukin 31 receptor A', '5q11.2'),
(37212, 'http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=37212', 'KLLN', 'killin; p53-regulated DNA replication inhibitor', '10q23');

-- --------------------------------------------------------

--
-- Table structure for table `genesynonym`
--

CREATE TABLE `genesynonym` (
  `HGNC_id` int(11) DEFAULT NULL COMMENT 'HGNC ID of the gene',
  `Gene_name` varchar(100) DEFAULT NULL COMMENT 'name of a gene, can be primary name or altname'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table contians all the gene name\neach name has a unique id as PK\nHGNC id is FK to table Gene';

--
-- Dumping data for table `genesynonym`
--

INSERT INTO `genesynonym` (`HGNC_id`, `Gene_name`) VALUES
(620, 'peptidase nexin-II'),
(14587, 'Eaf4'),
(14587, 'FLJ20089'),
(14587, 'MEAF4'),
(14587, 'p47ING3'),
(391, 'AKT'),
(391, 'PKB'),
(391, 'PRKBA'),
(391, 'RAC'),
(11916, 'CD120a'),
(11916, 'TNF-R'),
(11916, 'TNF-R-I'),
(11916, 'TNF-R55'),
(11916, 'TNFAR'),
(11916, 'TNFR60'),
(12405, 'CTS'),
(12405, 'HsT2651'),
(10683, 'cybS'),
(10683, 'small subunit of cytochrome b'),
(583, 'DP2'),
(583, 'DP2.5'),
(583, 'DP3'),
(583, 'PPP1R46'),
(583, 'protein phosphatase 1'),
(583, 'regulatory subunit 46'),
(3439, 'CSA'),
(3438, 'ARMD5'),
(3438, 'Cockayne syndrome B protein'),
(3438, 'CSB'),
(3438, 'RAD26'),
(9588, 'MMAC1'),
(9588, 'mutated in multiple advanced cancers 1'),
(9588, 'PTEN1'),
(9588, 'TEP1'),
(9122, 'HNPCC4'),
(9122, 'H_DJ0042M02.9'),
(9122, 'MLH4'),
(6119, 'LSIRF'),
(3690, 'CD333'),
(3690, 'CEK2'),
(3690, 'JTK4'),
(3436, 'FANCQ'),
(3436, 'RAD1'),
(3436, 'xeroderma pigmentosum'),
(3436, 'complementation group F'),
(9449, 'AltPrP'),
(9449, 'CD230'),
(9449, 'Creutzfeldt-Jakob disease'),
(9449, 'fatal familial insomnia'),
(9449, 'Gerstmann-Strausler-Scheinker syndrome'),
(9449, 'p27-30'),
(9449, 'PRP'),
(4620, 'amyloidosis'),
(4620, 'Finnish type'),
(4620, 'DKFZp313L0718'),
(10513, 'PIG4'),
(10513, 'TP53I4'),
(7127, 'FCC2'),
(7127, 'HNPCC'),
(7127, 'HNPCC2'),
(6740, 'renal amyloidosis'),
(11771, 'BIGH3'),
(11771, 'CDB1'),
(11771, 'CDGG1'),
(8507, 'OSMRB'),
(18969, 'CRL'),
(18969, 'CRL3'),
(18969, 'GLM-R'),
(18969, 'Glmr'),
(18969, 'IL-31RA'),
(8975, 'PI3K'),
(37212, 'killin'),
(6998, 'FMF'),
(6998, 'marenostrin'),
(6998, 'pyrin'),
(6998, 'TRIM20'),
(882, 'FRP1'),
(882, 'MEC1'),
(882, 'mitosis entry checkpoint 1'),
(882, 'homolog (S. cerevisiae)'),
(882, 'SCKL'),
(882, 'SCKL1'),
(11998, 'LFS1'),
(11998, 'Li-Fraumeni syndrome'),
(11998, 'p53'),
(10681, 'iron-sulfur subunit of complex II'),
(10681, 'succinate dehydrogenase [ubiquinone] iron-sulfur subunit'),
(11530, 'EGP-1'),
(11530, 'GA733-1'),
(11530, 'TROP2'),
(11529, '17-1A'),
(11529, '323/A3'),
(11529, 'CD326'),
(11529, 'CO-17A'),
(11529, 'EGP-2'),
(11529, 'EGP34'),
(11529, 'EGP40'),
(11529, 'Ep-CAM'),
(11529, 'ESA'),
(11529, 'GA733-2'),
(11529, 'HEA125'),
(11529, 'KS1/4'),
(11529, 'KSA'),
(11529, 'Ly74'),
(11529, 'MH99'),
(11529, 'MK-1'),
(11529, 'MOC31'),
(11529, 'TACST-1'),
(11529, 'TROP1'),
(16400, 'AGTAVPRL'),
(16400, 'AII'),
(16400, 'AVP'),
(16400, 'CLR1.1'),
(16400, 'Cryopyrin'),
(16400, 'FCAS'),
(16400, 'FCU'),
(16400, 'MWS'),
(16400, 'NALP3'),
(16400, 'nucleotide-binding oligomerization domain'),
(16400, 'leucine rich repeat and pyrin domain containing 3'),
(16400, 'PYPAF1'),
(11905, 'CD262'),
(11905, 'DR5'),
(11905, 'KILLER'),
(11905, 'TRAIL-R2'),
(11905, 'TRICK2A'),
(11905, 'TRICKB'),
(1582, 'B-cell CLL/lymphoma 1'),
(1582, 'G1/S-specific cyclin D1'),
(1582, 'parathyroid adenomatosis 1'),
(1582, 'U21B31'),
(6062, 'growth inhibitor ING1'),
(6062, 'growth inhibitory protein ING1'),
(6062, 'inhibitor of growth 1'),
(6062, 'p24ING1c'),
(6062, 'p33'),
(6062, 'p33ING1'),
(6062, 'p33ING1b'),
(6062, 'p47'),
(6062, 'p47ING1a'),
(6062, 'tumor suppressor ING1'),
(7325, 'HNPCC'),
(7325, 'HNPCC1'),
(12442, 'OCA1'),
(12442, 'OCA1A'),
(12442, 'OCAIA'),
(12442, 'oculocutaneous albinism IA');

-- --------------------------------------------------------

--
-- Table structure for table `protein`
--

CREATE TABLE `protein` (
  `Uniprot_entry_ID` varchar(45) NOT NULL COMMENT 'Uniprot entry ID can adreess a uniprot entry as well as a protein',
  `Uniprot_URL` varchar(100) NOT NULL COMMENT 'URL of this protein in Uniprot website',
  `Protein_Name` varchar(100) NOT NULL COMMENT 'Primary name of the Protein',
  `Sequence_Length` int(11) NOT NULL COMMENT 'length of the protein (aa)',
  `Mass` int(11) DEFAULT NULL COMMENT 'Mass of the Protein',
  `Target_disease` varchar(45) NOT NULL COMMENT 'text string to search a match to some records in UniProt.',
  `Author` varchar(45) DEFAULT NULL,
  `HGNC_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This is table of information about a protein\nfrom Uniprot. Each Protein have Uniprot entry\nas PK and servral attributes.\nHGNC ID is FK of table Gene';

--
-- Dumping data for table `protein`
--

INSERT INTO `protein` (`Uniprot_entry_ID`, `Uniprot_URL`, `Protein_Name`, `Sequence_Length`, `Mass`, `Target_disease`, `Author`, `HGNC_id`) VALUES
('B2CW77', 'http://www.uniprot.org/uniprot/B2CW77', 'Killin', 178, 19958, 'skin cancer', 'jywang', 37212),
('O14521', 'http://www.uniprot.org/uniprot/O14521', 'Succinate dehydrogenase [ubiquinone] cytochrome b small subunit, mitochondrial', 159, 17043, 'skin cancer', 'jywang', 10683),
('O14763', 'http://www.uniprot.org/uniprot/O14763', 'Tumor necrosis factor receptor superfamily member 10B', 440, 47878, 'skin cancer', 'jywang', 11905),
('O15553', 'http://www.uniprot.org/uniprot/O15553', 'Pyrin', 781, 86444, 'amyloidosis', 'jywang', 6998),
('P01034', 'http://www.uniprot.org/uniprot/P01034', 'Cystatin-C', 146, 15799, 'amyloidosis', 'jywang', 2475),
('P01857', 'http://www.uniprot.org/uniprot/P01857', 'Ig gamma-1 chain C region', 330, 36106, 'amyloidosis', 'jywang', 5525),
('P02647', 'http://www.uniprot.org/uniprot/P02647', 'Apolipoprotein A-I', 267, 30778, 'amyloidosis', 'jywang', 600),
('P02671', 'http://www.uniprot.org/uniprot/P02671', 'Fibrinogen alpha chain', 866, 94973, 'amyloidosis', 'jywang', 3661),
('P02766', 'http://www.uniprot.org/uniprot/P02766', 'Transthyretin', 147, 15887, 'amyloidosis', 'jywang', 12405),
('P04156', 'http://www.uniprot.org/uniprot/P04156', 'Major prion protein', 253, 27661, 'amyloidosis', 'jywang', 9449),
('P04637', 'http://www.uniprot.org/uniprot/P04637', 'Cellular tumor antigen p53', 393, 43653, 'skin cancer', 'jywang', 11998),
('P05067', 'http://www.uniprot.org/uniprot/P05067', 'Amyloid beta A4 protein', 770, 86943, 'amyloidosis', 'jywang', 620),
('P06396', 'http://www.uniprot.org/uniprot/P06396', 'Gelsolin', 782, 85698, 'amyloidosis', 'jywang', 4620),
('P09758', 'http://www.uniprot.org/uniprot/P09758', 'Tumor-associated calcium signal transducer 2', 323, 35709, 'amyloidosis', 'jywang', 11530),
('P0DJI8', 'http://www.uniprot.org/uniprot/P0DJI8', 'Serum amyloid A-1 protein', 122, 13532, 'amyloidosis', 'jywang', 10513),
('P0DJI9', 'http://www.uniprot.org/uniprot/P0DJI9', 'Serum amyloid A-2 protein', 122, 13527, 'amyloidosis', 'jywang', 10514),
('P14679', 'http://www.uniprot.org/uniprot/P14679', 'Tyrosinase', 529, 60393, 'skin cancer', 'jywang', 12442),
('P16422', 'http://www.uniprot.org/uniprot/P16422', 'Epithelial cell adhesion molecule', 314, 34932, 'skin cancer', 'jywang', 11529),
('P19438', 'http://www.uniprot.org/uniprot/P19438', 'Tumor necrosis factor receptor superfamily member 1A', 455, 50495, 'amyloidosis', 'jywang', 11916),
('P21912', 'http://www.uniprot.org/uniprot/P21912', 'Succinate dehydrogenase [ubiquinone] iron-sulfur subunit, mitochondrial', 280, 31630, 'skin cancer', 'jywang', 10681),
('P22607', 'http://www.uniprot.org/uniprot/P22607', 'Fibroblast growth factor receptor 3', 806, 87710, 'amyloidosis', 'jywang', 3690),
('P24385', 'http://www.uniprot.org/uniprot/P24385', 'G1/S-specific cyclin-D1', 295, 33729, 'amyloidosis', 'jywang', 1582),
('P25054', 'http://www.uniprot.org/uniprot/P25054', 'Adenomatous polyposis coli protein', 2843, 311646, 'skin cancer', 'jywang', 583),
('P31749', 'http://www.uniprot.org/uniprot/P31749', 'RAC-alpha serine/threonine-protein kinase', 480, 55686, 'skin cancer', 'jywang', 391),
('P37173', 'http://www.uniprot.org/uniprot/P37173', 'TGF-beta receptor type-2', 567, 64568, 'skin cancer', 'jywang', 11773),
('P40692', 'http://www.uniprot.org/uniprot/P40692', 'DNA mismatch repair protein Mlh1', 756, 84601, 'skin cancer', 'jywang', 7127),
('P42336', 'http://www.uniprot.org/uniprot/P42336', 'Phosphatidylinositol 4,5-bisphosphate 3-kinase catalytic subunit alpha isoform', 1068, 124284, 'skin cancer', 'jywang', 8975),
('P43246', 'http://www.uniprot.org/uniprot/P43246', 'DNA mismatch repair protein Msh2', 934, 104743, 'skin cancer', 'jywang', 7325),
('P52701', 'http://www.uniprot.org/uniprot/P52701', 'DNA mismatch repair protein Msh6', 1360, 152786, 'skin cancer', 'jywang', 7329),
('P54278', 'http://www.uniprot.org/uniprot/P54278', 'Mismatch repair endonuclease PMS2', 862, 95797, 'skin cancer', 'jywang', 9122),
('P60484', 'http://www.uniprot.org/uniprot/P60484', 'Phosphatidylinositol 3,4,5-trisphosphate 3-phosphatase and dual-specificity protein phosphatase PTEN', 403, 47166, 'skin cancer', 'jywang', 9588),
('P61626', 'http://www.uniprot.org/uniprot/P61626', 'Lysozyme C', 148, 16537, 'amyloidosis', 'jywang', 6740),
('P61769', 'http://www.uniprot.org/uniprot/P61769', 'Beta-2-microglobulin', 119, 13715, 'amyloidosis', 'jywang', 914),
('Q03468', 'http://www.uniprot.org/uniprot/Q03468', 'DNA excision repair protein ERCC-6', 1493, 168416, 'skin cancer', 'jywang', 3438),
('Q13216', 'http://www.uniprot.org/uniprot/Q13216', 'DNA excision repair protein ERCC-8', 396, 44055, 'skin cancer', 'jywang', 3439),
('Q13535', 'http://www.uniprot.org/uniprot/Q13535', 'Serine/threonine-protein kinase ATR', 2644, 301367, 'skin cancer', 'jywang', 882),
('Q15306', 'http://www.uniprot.org/uniprot/Q15306', 'Interferon regulatory factor 4', 451, 51772, 'amyloidosis', 'jywang', 6119),
('Q15582', 'http://www.uniprot.org/uniprot/Q15582', 'Transforming growth factor-beta-induced protein ig-h3', 683, 74681, 'amyloidosis', 'jywang', 11771),
('Q8NI17', 'http://www.uniprot.org/uniprot/Q8NI17', 'Interleukin-31 receptor subunit alpha', 732, 82954, 'amyloidosis', 'jywang', 18969),
('Q92889', 'http://www.uniprot.org/uniprot/Q92889', 'DNA repair endonuclease XPF', 916, 104486, 'skin cancer', 'jywang', 3436),
('Q96P20', 'http://www.uniprot.org/uniprot/Q96P20', 'NACHT, LRR and PYD domains-containing protein 3', 1036, 118173, 'amyloidosis', 'jywang', 16400),
('Q99650', 'http://www.uniprot.org/uniprot/Q99650', 'Oncostatin-M-specific receptor subunit beta', 979, 110509, 'amyloidosis', 'jywang', 8507),
('Q9BXB1', 'http://www.uniprot.org/uniprot/Q9BXB1', 'Leucine-rich repeat-containing G-protein coupled receptor 4', 951, 104475, 'skin cancer', 'jywang', 13299),
('Q9NXR8', 'http://www.uniprot.org/uniprot/Q9NXR8', 'Inhibitor of growth protein 3', 418, 46743, 'skin cancer', 'jywang', 14587),
('Q9UHC1', 'http://www.uniprot.org/uniprot/Q9UHC1', 'DNA mismatch repair protein Mlh3', 1453, 163711, 'skin cancer', 'jywang', 7128),
('Q9UK53', 'http://www.uniprot.org/uniprot/Q9UK53', 'Inhibitor of growth protein 1', 422, 46738, 'skin cancer', 'jywang', 6062);

-- --------------------------------------------------------

--
-- Table structure for table `proteinsynonym`
--

CREATE TABLE `proteinsynonym` (
  `Uniprot_entry_id` varchar(45) NOT NULL COMMENT 'Uniprot entry ID of the Protein',
  `Protein_name` varchar(100) NOT NULL COMMENT 'Name of hte Protein, can be primary name or alt name'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='entity Protein name is use\nto store all the name of protein\nin this database, each name map\nto one protein and have a unique id\nas PK\nUNiprot entry is FK of  table Protein';

--
-- Dumping data for table `proteinsynonym`
--

INSERT INTO `proteinsynonym` (`Uniprot_entry_id`, `Protein_name`) VALUES
('P05067', 'ABPP'),
('P05067', 'APPI'),
('P05067', 'Alzheimer disease amyloid protein'),
('P05067', 'Cerebral vascular amyloid peptide'),
('P05067', 'PreA4'),
('P05067', 'Protease nexin-II'),
('Q9NXR8', 'p47ING3'),
('P31749', 'Protein kinase B'),
('P31749', 'Protein kinase B alpha'),
('P31749', 'Proto-oncogene c-Akt'),
('P31749', 'RAC-PK-alpha'),
('P19438', 'Tumor necrosis factor receptor 1'),
('P19438', 'Tumor necrosis factor receptor type I'),
('P19438', 'p55'),
('P19438', 'p60'),
('P02647', 'Apolipoprotein A1'),
('P02766', 'ATTR'),
('P02766', 'Prealbumin'),
('P02766', 'TBPA'),
('O14521', 'CII-4'),
('O14521', 'QPs3'),
('O14521', 'Succinate dehydrogenase complex subunit D'),
('O14521', 'Succinate-ubiquinone oxidoreductase cytochrome b small subunit'),
('O14521', 'Succinate-ubiquinone reductase membrane anchor subunit'),
('P25054', 'Deleted in polyposis 2.5'),
('Q13216', 'Cockayne syndrome WD repeat protein CSA'),
('Q03468', 'ATP-dependent helicase ERCC6'),
('Q03468', 'Cockayne syndrome protein CSB'),
('P60484', 'Mutated in multiple advanced cancers 1'),
('P60484', 'Phosphatase and tensin homolog'),
('P54278', 'DNA mismatch repair protein PMS2'),
('P54278', 'PMS1 protein homolog 2'),
('Q15306', 'Lymphocyte-specific interferon regulatory factor'),
('Q15306', 'Multiple myeloma oncogene 1'),
('Q15306', 'NF-EM5'),
('Q9UHC1', 'MutL protein homolog 3'),
('Q92889', 'DNA excision repair protein ERCC-4'),
('Q92889', 'DNA repair protein complementing XP-F cells'),
('Q92889', 'Xeroderma pigmentosum group F-complementing protein'),
('P04156', 'ASCR'),
('P04156', 'PrP27-30'),
('P04156', 'PrP33-35C'),
('P06396', 'AGEL'),
('P06396', 'Actin-depolymerizing factor'),
('P06396', 'Brevin'),
('P40692', 'MutL protein homolog 1'),
('P61626', '1,4-beta-N-acetylmuramidase C'),
('Q15582', 'Kerato-epithelin'),
('Q15582', 'RGD-containing collagen-associated protein'),
('Q99650', 'Interleukin-31 receptor subunit beta'),
('Q9BXB1', 'G-protein coupled receptor 48'),
('Q8NI17', 'Cytokine receptor-like 3'),
('Q8NI17', 'GLM-R'),
('Q8NI17', 'Gp130-like monocyte receptor'),
('Q8NI17', 'ZcytoR17'),
('P42336', 'Phosphatidylinositol 4'),
('P42336', '5-bisphosphate 3-kinase 110 kDa catalytic subunit alpha'),
('P42336', 'Phosphoinositide-3-kinase catalytic alpha polypeptide'),
('P42336', 'Serine/threonine protein kinase PIK3CA'),
('P37173', 'TGF-beta type II receptor'),
('P37173', 'Transforming growth factor-beta receptor type II'),
('O15553', 'Marenostrin'),
('Q13535', 'Ataxia telangiectasia and Rad3-related protein'),
('Q13535', 'FRAP-related protein 1'),
('P04637', 'Antigen NY-CO-13'),
('P04637', 'Phosphoprotein p53'),
('P04637', 'Tumor suppressor p53'),
('P21912', 'Iron-sulfur subunit of complex II'),
('P09758', 'Cell surface glycoprotein Trop-2'),
('P09758', 'Membrane component chromosome 1 surface marker 1'),
('P09758', 'Pancreatic carcinoma marker protein GA733-1'),
('P16422', 'Adenocarcinoma-associated antigen'),
('P16422', 'Cell surface glycoprotein Trop-1'),
('P16422', 'Epithelial cell surface antigen'),
('P16422', 'Epithelial glycoprotein'),
('P16422', 'Epithelial glycoprotein 314'),
('P16422', 'KS 1/4 antigen'),
('P16422', 'KSA'),
('P16422', 'Major gastrointestinal tumor-associated protein GA733-2'),
('P16422', 'Tumor-associated calcium signal transducer 1'),
('P52701', 'G/T mismatch-binding protein'),
('P52701', 'MutS-alpha 160 kDa subunit'),
('Q96P20', 'Angiotensin/vasopressin receptor AII/AVP-like'),
('Q96P20', 'Caterpiller protein 1.1'),
('Q96P20', 'Cold-induced autoinflammatory syndrome 1 protein'),
('Q96P20', 'Cryopyrin'),
('Q96P20', 'PYRIN-containing APAF1-like protein 1'),
('O14763', 'Death receptor 5'),
('O14763', 'TNF-related apoptosis-inducing ligand receptor 2'),
('P24385', 'B-cell lymphoma 1 protein'),
('P24385', 'BCL-1 oncogene'),
('P24385', 'PRAD1 oncogene'),
('P43246', 'MutS protein homolog 2'),
('P01034', 'Cystatin-3'),
('P01034', 'Gamma-trace'),
('P01034', 'Neuroendocrine basic polypeptide'),
('P01034', 'Post-gamma-globulin'),
('P14679', 'LB24-AB'),
('P14679', 'Monophenol monooxygenase'),
('P14679', 'SK29-AB'),
('P14679', 'Tumor rejection antigen AB');

-- --------------------------------------------------------

--
-- Stand-in structure for view `search_disease_name`
--
CREATE TABLE `search_disease_name` (
`Uniprot_Disease_Name` varchar(200)
,`MIM_phenotype_id` varchar(300)
,`Uniprot_entry_id` varchar(300)
,`protein_name` varchar(100)
,`HGNC_id` varchar(300)
,`gene_name` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `uniprotomimdorelationship`
--

CREATE TABLE `uniprotomimdorelationship` (
  `MIM_phenotype_id` int(11) NOT NULL,
  `DO_id` int(11) NOT NULL COMMENT 'Disease Ontology ID',
  `UniPro_disease_name` varchar(200) NOT NULL,
  `Uniprot_entry_id` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table descirbe relationship between\nMIM phenotype and Disease Ontology\nAll the column is PK\nDOID is FK to DO';

--
-- Dumping data for table `uniprotomimdorelationship`
--

INSERT INTO `uniprotomimdorelationship` (`MIM_phenotype_id`, `DO_id`, `UniPro_disease_name`, `Uniprot_entry_id`) VALUES
(100800, 4480, 'Achondroplasia', 'P22607'),
(104300, 10652, 'Alzheimer disease 1', 'P05067'),
(105120, 50637, 'Amyloidosis 5', 'P06396'),
(105200, 50636, 'Amyloidosis 8', 'P61626'),
(105210, 50638, 'Amyloidosis, transthyretin-related', 'P02766'),
(114480, 1612, 'Breast cancer', 'P31749'),
(114500, 1520, 'Colorectal cancer', 'P31749'),
(114500, 9256, 'Colorectal cancer', 'P31749'),
(121820, 60447, 'Corneal dystrophy, epithelial basement membrane', 'Q15582'),
(133540, 2962, 'Cockayne syndrome B', 'Q03468'),
(158350, 6457, 'Cowden syndrome 1', 'P60484'),
(168000, 50773, 'Paragangliomas 1', 'O14521'),
(175100, 50424, 'Familial adenomatous polyposis', 'P25054'),
(176920, 13482, 'Proteus syndrome', 'P31749'),
(202400, 2236, 'Congenital afibrinogenemia', 'P02671'),
(216400, 2962, 'Cockayne syndrome A', 'Q13216'),
(254500, 9538, 'Multiple myeloma', 'Q15306'),
(275355, 5520, 'Squamous cell carcinoma of the head and neck', 'Q9NXR8'),
(278760, 50427, 'Xeroderma pigmentosum complementation group F', 'Q92889'),
(605714, 9246, 'Cerebral amyloid angiopathy, APP-related', 'P05067'),
(609310, 3883, 'Hereditary non-polyposis colorectal cancer 2', 'P40692'),
(614337, 3883, 'Hereditary non-polyposis colorectal cancer 4', 'P54278'),
(614385, 3883, 'Hereditary non-polyposis colorectal cancer 7', 'Q9UHC1');

-- --------------------------------------------------------

--
-- Table structure for table `uniprotomimrelationship`
--

CREATE TABLE `uniprotomimrelationship` (
  `MIM_phenotype_id` int(11) NOT NULL COMMENT 'ID of the disease on MIM database',
  `UniPro_disease_name` varchar(200) NOT NULL COMMENT 'Name of the Disease',
  `Uniprot_entry_id` varchar(45) NOT NULL COMMENT 'entry of Uniprot protein'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This relationship is about MIM phenotype and Protein\nMIM phenotype ID and Uniprot entry Id  and Uniprot Disease name  serves as PK\nUniprot entry id, Uniprot Disease nanme and MIM phenotype Id  is FK to table Disease Onotology MIM relation\nUniprot entry Id is FK to Protein\nUniprot Disease name  is FK to table MIM phenotype';

--
-- Dumping data for table `uniprotomimrelationship`
--

INSERT INTO `uniprotomimrelationship` (`MIM_phenotype_id`, `UniPro_disease_name`, `Uniprot_entry_id`) VALUES
(100800, 'Achondroplasia', 'P22607'),
(104300, 'Alzheimer disease 1', 'P05067'),
(105120, 'Amyloidosis 5', 'P06396'),
(105150, 'Amyloidosis 6', 'P01034'),
(105200, 'Amyloidosis 8', 'P02647'),
(105200, 'Amyloidosis 8', 'P02671'),
(105200, 'Amyloidosis 8', 'P61626'),
(105210, 'Amyloidosis, transthyretin-related', 'P02766'),
(105250, 'Amyloidosis, primary localized cutaneous, 1', 'Q99650'),
(114480, 'Breast cancer', 'P31749'),
(114480, 'Breast cancer', 'P42336'),
(114500, 'Colorectal cancer', 'P31749'),
(114500, 'Colorectal cancer', 'P42336'),
(114500, 'Colorectal cancer', 'Q9UHC1'),
(114900, 'Intestinal carcinoid tumor', 'O14521'),
(115310, 'Paragangliomas 4', 'P21912'),
(115430, 'Carpal tunnel syndrome 1', 'P02766'),
(120100, 'Familial cold autoinflammatory syndrome 1', 'Q96P20'),
(120435, 'Hereditary non-polyposis colorectal cancer 1', 'P43246'),
(121820, 'Corneal dystrophy, epithelial basement membrane', 'Q15582'),
(121900, 'Corneal dystrophy, Groenouw type 1', 'Q15582'),
(122200, 'Corneal dystrophy, lattice type 1', 'Q15582'),
(123400, 'Creutzfeldt-Jakob disease', 'P04156'),
(133239, 'Esophageal cancer', 'P04637'),
(133239, 'Esophageal cancer', 'P37173'),
(133540, 'Cockayne syndrome B', 'Q03468'),
(134610, 'Familial Mediterranean fever, autosomal dominant', 'O15553'),
(135290, 'Hereditary desmoid disease', 'P25054'),
(137440, 'Gerstmann-Straussler disease', 'P04156'),
(142680, 'Familial hibernian fever', 'P19438'),
(145680, 'Hyperthyroxinemia, dystransthyretinemic', 'P02766'),
(151623, 'Li-Fraumeni syndrome', 'P04637'),
(153480, 'Bannayan-Riley-Ruvalcaba syndrome', 'P60484'),
(155255, 'Medulloblastoma', 'P25054'),
(158320, 'Muir-Torre syndrome', 'P40692'),
(158320, 'Muir-Torre syndrome', 'P43246'),
(158350, 'Cowden syndrome 1', 'P60484'),
(158350, 'Lhermitte-Duclos disease', 'P60484'),
(166710, 'Osteoporosis', 'Q9BXB1'),
(167000, 'Ovarian cancer', 'P42336'),
(168000, 'Paragangliomas 1', 'O14521'),
(171300, 'Pheochromocytoma', 'O14521'),
(171300, 'Pheochromocytoma', 'P21912'),
(175100, 'Familial adenomatous polyposis', 'P25054'),
(176920, 'Proteus syndrome', 'P31749'),
(187600, 'Thanatophoric dysplasia 1', 'P22607'),
(187601, 'Thanatophoric dysplasia 2', 'P22607'),
(191900, 'Muckle-Wells syndrome', 'Q96P20'),
(202400, 'Congenital afibrinogenemia', 'P02671'),
(203100, 'Albinism, oculocutaneous, 1A', 'P14679'),
(204870, 'Corneal dystrophy, gelatinous drop-like', 'P09758'),
(205400, 'High density lipoprotein deficiency 1', 'P02647'),
(210600, 'Seckel syndrome 1', 'Q13535'),
(214150, 'Cerebro-oculo-facio-skeletal syndrome 1', 'Q03468'),
(216400, 'Cockayne syndrome A', 'Q13216'),
(241600, 'Hypercatabolic hypoproteinemia', 'P61769'),
(249100, 'Familial Mediterranean fever, autosomal recessive', 'O15553'),
(254500, 'Multiple myeloma', 'P01857'),
(254500, 'Multiple myeloma', 'P24385'),
(254500, 'Multiple myeloma', 'Q15306'),
(275355, 'Squamous cell carcinoma of the head and neck', 'O14763'),
(275355, 'Squamous cell carcinoma of the head and neck', 'P04637'),
(275355, 'Squamous cell carcinoma of the head and neck', 'P60484'),
(275355, 'Squamous cell carcinoma of the head and neck', 'Q9NXR8'),
(275355, 'Squamous cell carcinoma of the head and neck', 'Q9UK53'),
(276300, 'Mismatch repair cancer syndrome', 'P25054'),
(276300, 'Mismatch repair cancer syndrome', 'P40692'),
(276300, 'Mismatch repair cancer syndrome', 'P52701'),
(276300, 'Mismatch repair cancer syndrome', 'P54278'),
(278760, 'Xeroderma pigmentosum complementation group F', 'Q92889'),
(278760, 'Xeroderma pigmentosum type F/Cockayne syndrome', 'Q92889'),
(278800, 'De Sanctis-Cacchione syndrome', 'Q03468'),
(600072, 'Fatal familial insomnia', 'P04156'),
(602082, 'Corneal dystrophy, Thiel-Behnke type', 'Q15582'),
(604091, 'High density lipoprotein deficiency 2', 'P02647'),
(605714, 'Cerebral amyloid angiopathy, APP-related', 'P05067'),
(606864, 'Paraganglioma and gastric stromal sarcoma', 'O14521'),
(606864, 'Paraganglioma and gastric stromal sarcoma', 'P21912'),
(606952, 'Albinism, oculocutaneous, 1B', 'P14679'),
(607115, 'Chronic infantile neurologic cutaneous and articular syndrome', 'Q96P20'),
(608089, 'Endometrial cancer', 'P43246'),
(608089, 'Endometrial cancer', 'P52701'),
(609310, 'Hereditary non-polyposis colorectal cancer 2', 'P40692'),
(610168, 'Loeys-Dietz syndrome 2', 'P37173'),
(610965, 'XFE progeroid syndrome', 'Q92889'),
(611953, 'Macular degeneration, age-related, 11', 'P01034'),
(612247, 'Crouzon syndrome with acanthosis nigricans', 'P22607'),
(612359, 'Cowden syndrome 2', 'P21912'),
(613217, 'Diarrhea 5, with tufting enteropathy, congenital', 'P16422'),
(613244, 'Hereditary non-polyposis colorectal cancer 8', 'P16422'),
(613761, 'Macular degeneration, age-related, 5', 'Q03468'),
(613955, 'Amyloidosis, primary localized cutaneous, 2', 'Q8NI17'),
(614331, 'Hereditary non-polyposis colorectal cancer 6', 'P37173'),
(614337, 'Hereditary non-polyposis colorectal cancer 4', 'P54278'),
(614350, 'Hereditary non-polyposis colorectal cancer 5', 'P52701'),
(614385, 'Hereditary non-polyposis colorectal cancer 7', 'Q9UHC1'),
(614564, 'Cutaneous telangiectasia and cancer syndrome, familial', 'Q13535'),
(614621, 'UV-sensitive syndrome 2', 'Q13216'),
(614810, 'Multiple sclerosis 5', 'P19438'),
(615107, 'Cowden syndrome 4', 'B2CW77'),
(615272, 'Fanconi anemia complementation group Q', 'Q92889'),
(616004, 'Dysfibrinogenemia, congenital', 'P02671');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_do`
--
CREATE TABLE `vw_do` (
`DO_id` int(11)
,`Disease_Name` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_gene`
--
CREATE TABLE `vw_gene` (
`HGNC_id` int(11)
,`Approved_Symbol` varchar(100)
,`Chromosome_location` varchar(45)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_mim`
--
CREATE TABLE `vw_mim` (
`MIM_phenotype_id` int(11)
,`UniPro_disease_name` varchar(200)
,`Uniprot_entry_ID` varchar(45)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_mim_do`
--
CREATE TABLE `vw_mim_do` (
`Uniprot_entry_ID` varchar(45)
,`MIMphnotypes` text
,`Uniprot_disease_names` text
,`DO_ids` text
,`DO_disease_names` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_mimdo`
--
CREATE TABLE `vw_mimdo` (
`MIM_phenotype_id` int(11)
,`number_of_do` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_pdo`
--
CREATE TABLE `vw_pdo` (
`Uniprot_entry_id` varchar(45)
,`number_of_do` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_pname`
--
CREATE TABLE `vw_pname` (
`Uniprot_entry_ID` varchar(45)
,`Altnames` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_protein`
--
CREATE TABLE `vw_protein` (
`Target_disease` varchar(45)
,`Uniprot_entry_ID` varchar(45)
,`Protein_Name` varchar(100)
,`Sequence_Length` int(11)
,`HGNC_id` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_ptop`
--
CREATE TABLE `vw_ptop` (
`Uniprot_entry_ID` varchar(45)
,`Target_disease` varchar(45)
,`Protein_Name` varchar(100)
,`Sequence_Length` int(11)
,`HGNC_id` int(11)
,`Approved_Symbol` varchar(100)
,`Chromosome_location` varchar(45)
,`altername` text
,`MIMphnotypes` text
,`Uniprot_disease_names` text
,`DO_ids` text
,`DO_disease_names` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_stat_1`
--
CREATE TABLE `vw_stat_1` (
`join_label` varchar(1)
,`number_of_protein_with_do` decimal(23,0)
,`number_of_protein_without_do` decimal(23,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_stat_2`
--
CREATE TABLE `vw_stat_2` (
`join_label` varchar(1)
,`number_of_mim_with_do` decimal(23,0)
,`number_of_mim_without_do` decimal(23,0)
);

-- --------------------------------------------------------

--
-- Structure for view `search_disease_name`
--
DROP TABLE IF EXISTS `search_disease_name`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `search_disease_name`  AS  select distinct `a`.`UniPro_disease_name` AS `Uniprot_Disease_Name`,`HTMLLink`(`a`.`MIM_phenotype_id`,'m') AS `MIM_phenotype_id`,`HTMLLink`(`b`.`Uniprot_entry_ID`,'p') AS `Uniprot_entry_id`,`b`.`Protein_Name` AS `protein_name`,`HTMLLink`(`b`.`HGNC_id`,'g') AS `HGNC_id`,`d`.`Approved_Name` AS `gene_name` from (((`uniprotomimrelationship` `a` left join `protein` `b` on((`a`.`Uniprot_entry_id` = `b`.`Uniprot_entry_ID`))) left join `uniprotomimdorelationship` `c` on((`a`.`UniPro_disease_name` = `c`.`UniPro_disease_name`))) left join `gene` `d` on((`b`.`HGNC_id` = `d`.`HGNC_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_do`
--
DROP TABLE IF EXISTS `vw_do`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_do`  AS  select `do`.`DO_id` AS `DO_id`,`do`.`Disease_Name` AS `Disease_Name` from `do` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_gene`
--
DROP TABLE IF EXISTS `vw_gene`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_gene`  AS  select `gene`.`HGNC_id` AS `HGNC_id`,`gene`.`Approved_Symbol` AS `Approved_Symbol`,`gene`.`Chromosome_location` AS `Chromosome_location` from `gene` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_mim`
--
DROP TABLE IF EXISTS `vw_mim`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mim`  AS  select `uniprotomimrelationship`.`MIM_phenotype_id` AS `MIM_phenotype_id`,`uniprotomimrelationship`.`UniPro_disease_name` AS `UniPro_disease_name`,`uniprotomimrelationship`.`Uniprot_entry_id` AS `Uniprot_entry_ID` from `uniprotomimrelationship` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_mim_do`
--
DROP TABLE IF EXISTS `vw_mim_do`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mim_do`  AS  select `a`.`Uniprot_entry_id` AS `Uniprot_entry_ID`,ifnull(group_concat(`b`.`MIM_phenotype_id` separator '; '),'none') AS `MIMphnotypes`,ifnull(group_concat(`b`.`UniPro_disease_name` separator ':'),'none') AS `Uniprot_disease_names`,ifnull(group_concat(`b`.`DO_id` separator ':'),'none') AS `DO_ids`,ifnull(group_concat(`c`.`Disease_Name` separator ':'),'none') AS `DO_disease_names` from ((`uniprotomimrelationship` `a` left join `uniprotomimdorelationship` `b` on(((`a`.`UniPro_disease_name` = `b`.`UniPro_disease_name`) or (`a`.`Uniprot_entry_id` = `b`.`Uniprot_entry_id`) or (`a`.`MIM_phenotype_id` = `b`.`MIM_phenotype_id`)))) left join `do` `c` on((`b`.`DO_id` = `c`.`DO_id`))) group by `a`.`Uniprot_entry_id` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_mimdo`
--
DROP TABLE IF EXISTS `vw_mimdo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mimdo`  AS  select `a`.`MIM_phenotype_id` AS `MIM_phenotype_id`,count(`b`.`DO_id`) AS `number_of_do` from (`uniprotomimrelationship` `a` left join `uniprotomimdorelationship` `b` on(((`a`.`UniPro_disease_name` = `b`.`UniPro_disease_name`) and (`a`.`Uniprot_entry_id` = `b`.`Uniprot_entry_id`) and (`a`.`MIM_phenotype_id` = `b`.`MIM_phenotype_id`)))) group by `a`.`MIM_phenotype_id` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_pdo`
--
DROP TABLE IF EXISTS `vw_pdo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_pdo`  AS  select `a`.`Uniprot_entry_ID` AS `Uniprot_entry_id`,count(`b`.`DO_id`) AS `number_of_do` from (`protein` `a` left join `uniprotomimdorelationship` `b` on((`a`.`Uniprot_entry_ID` = `b`.`Uniprot_entry_id`))) group by `a`.`Uniprot_entry_ID` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_pname`
--
DROP TABLE IF EXISTS `vw_pname`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_pname`  AS  select `a`.`Uniprot_entry_ID` AS `Uniprot_entry_ID`,ifnull(group_concat(`b`.`Protein_name` order by `b`.`Protein_name` ASC separator '; '),'none') AS `Altnames` from (`protein` `a` left join `proteinsynonym` `b` on((`a`.`Uniprot_entry_ID` = `b`.`Uniprot_entry_id`))) group by `a`.`Uniprot_entry_ID` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_protein`
--
DROP TABLE IF EXISTS `vw_protein`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_protein`  AS  select `protein`.`Target_disease` AS `Target_disease`,`protein`.`Uniprot_entry_ID` AS `Uniprot_entry_ID`,`protein`.`Protein_Name` AS `Protein_Name`,`protein`.`Sequence_Length` AS `Sequence_Length`,`protein`.`HGNC_id` AS `HGNC_id` from `protein` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_ptop`
--
DROP TABLE IF EXISTS `vw_ptop`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ptop`  AS  select `a`.`Uniprot_entry_ID` AS `Uniprot_entry_ID`,`a`.`Target_disease` AS `Target_disease`,`a`.`Protein_Name` AS `Protein_Name`,`a`.`Sequence_Length` AS `Sequence_Length`,`a`.`HGNC_id` AS `HGNC_id`,`b`.`Approved_Symbol` AS `Approved_Symbol`,`b`.`Chromosome_location` AS `Chromosome_location`,`c`.`Altnames` AS `altername`,ifnull(`d`.`MIMphnotypes`,'none') AS `MIMphnotypes`,ifnull(`d`.`Uniprot_disease_names`,'none') AS `Uniprot_disease_names`,ifnull(`d`.`DO_ids`,'none') AS `DO_ids`,ifnull(`d`.`DO_disease_names`,'none') AS `DO_disease_names` from (((`vw_protein` `a` left join `vw_gene` `b` on((`a`.`HGNC_id` = `b`.`HGNC_id`))) left join `vw_pname` `c` on((`a`.`Uniprot_entry_ID` = `c`.`Uniprot_entry_ID`))) left join `vw_mim_do` `d` on((`d`.`Uniprot_entry_ID` = `a`.`Uniprot_entry_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_stat_1`
--
DROP TABLE IF EXISTS `vw_stat_1`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_stat_1`  AS  select 'a' AS `join_label`,sum(if((`vw_pdo`.`number_of_do` > 0),1,0)) AS `number_of_protein_with_do`,sum(if((`vw_pdo`.`number_of_do` > 0),0,1)) AS `number_of_protein_without_do` from `vw_pdo` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_stat_2`
--
DROP TABLE IF EXISTS `vw_stat_2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_stat_2`  AS  select 'a' AS `join_label`,sum(if((`vw_mimdo`.`number_of_do` > 0),1,0)) AS `number_of_mim_with_do`,sum(if((`vw_mimdo`.`number_of_do` > 0),0,1)) AS `number_of_mim_without_do` from `vw_mimdo` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dieasename`
--
ALTER TABLE `dieasename`
  ADD PRIMARY KEY (`Uniprot_Disease_name`);

--
-- Indexes for table `do`
--
ALTER TABLE `do`
  ADD PRIMARY KEY (`DO_id`);

--
-- Indexes for table `gene`
--
ALTER TABLE `gene`
  ADD PRIMARY KEY (`HGNC_id`);

--
-- Indexes for table `genesynonym`
--
ALTER TABLE `genesynonym`
  ADD KEY `HGNC ID_idx` (`HGNC_id`);

--
-- Indexes for table `protein`
--
ALTER TABLE `protein`
  ADD PRIMARY KEY (`Uniprot_entry_ID`),
  ADD KEY `fk_Protein_Gene1_idx` (`HGNC_id`);

--
-- Indexes for table `proteinsynonym`
--
ALTER TABLE `proteinsynonym`
  ADD KEY `Uniprot entry ID_idx` (`Uniprot_entry_id`);

--
-- Indexes for table `uniprotomimdorelationship`
--
ALTER TABLE `uniprotomimdorelationship`
  ADD PRIMARY KEY (`MIM_phenotype_id`,`DO_id`,`UniPro_disease_name`,`Uniprot_entry_id`),
  ADD KEY `fk3_idx` (`DO_id`),
  ADD KEY `fk_UniprotOMIMDORelationship_UniprotOMIMRelationship1_idx` (`MIM_phenotype_id`,`Uniprot_entry_id`,`UniPro_disease_name`);

--
-- Indexes for table `uniprotomimrelationship`
--
ALTER TABLE `uniprotomimrelationship`
  ADD PRIMARY KEY (`MIM_phenotype_id`,`Uniprot_entry_id`,`UniPro_disease_name`),
  ADD KEY `fk2_idx` (`UniPro_disease_name`),
  ADD KEY `fk_idx` (`Uniprot_entry_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `genesynonym`
--
ALTER TABLE `genesynonym`
  ADD CONSTRAINT `HGNC ID` FOREIGN KEY (`HGNC_id`) REFERENCES `gene` (`HGNC_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `protein`
--
ALTER TABLE `protein`
  ADD CONSTRAINT `fk_Protein_Gene1` FOREIGN KEY (`HGNC_id`) REFERENCES `gene` (`HGNC_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `proteinsynonym`
--
ALTER TABLE `proteinsynonym`
  ADD CONSTRAINT `Uniprot entry ID` FOREIGN KEY (`Uniprot_entry_id`) REFERENCES `protein` (`Uniprot_entry_ID`);

--
-- Constraints for table `uniprotomimdorelationship`
--
ALTER TABLE `uniprotomimdorelationship`
  ADD CONSTRAINT `fk3` FOREIGN KEY (`DO_id`) REFERENCES `do` (`DO_id`),
  ADD CONSTRAINT `fk_UniprotOMIMDORelationship_UniprotOMIMRelationship1` FOREIGN KEY (`MIM_phenotype_id`,`Uniprot_entry_id`,`UniPro_disease_name`) REFERENCES `uniprotomimrelationship` (`MIM_phenotype_id`, `Uniprot_entry_id`, `UniPro_disease_name`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `uniprotomimrelationship`
--
ALTER TABLE `uniprotomimrelationship`
  ADD CONSTRAINT `fk` FOREIGN KEY (`Uniprot_entry_id`) REFERENCES `protein` (`Uniprot_entry_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk2` FOREIGN KEY (`UniPro_disease_name`) REFERENCES `dieasename` (`Uniprot_Disease_name`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

#include <stdio.h>
#include <iostream>
#include <assert.h>
#include "circom.hpp"
#include "calcwit.hpp"
void ToBits_0_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void ToBits_0_run(uint ctx_index,Circom_CalcWit* ctx);
void XorWordConst_1_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void XorWordConst_1_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3Permute_2_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3Permute_2_run(uint ctx_index,Circom_CalcWit* ctx);
void Bits34_3_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Bits34_3_run(uint ctx_index,Circom_CalcWit* ctx);
void Bits33_4_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Bits33_4_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRight_5_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRight_5_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRightWord_6_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRightWord_6_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRight_7_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRight_7_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRightWord_8_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRightWord_8_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRight_9_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRight_9_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRightWord_10_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRightWord_10_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRight_11_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRight_11_run(uint ctx_index,Circom_CalcWit* ctx);
void RotRightWord_12_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void RotRightWord_12_run(uint ctx_index,Circom_CalcWit* ctx);
void XOR2_13_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void XOR2_13_run(uint ctx_index,Circom_CalcWit* ctx);
void XorWord2_14_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void XorWord2_14_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_15_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_15_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_16_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_16_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_17_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_17_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_18_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_18_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_19_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_19_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_20_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_20_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_21_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_21_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3G_22_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3G_22_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3Round_23_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3Round_23_run(uint ctx_index,Circom_CalcWit* ctx);
void XOR3_24_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void XOR3_24_run(uint ctx_index,Circom_CalcWit* ctx);
void XorWord3_25_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void XorWord3_25_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3Compress_26_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3Compress_26_run(uint ctx_index,Circom_CalcWit* ctx);
void Blake3Bytes_27_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Blake3Bytes_27_run(uint ctx_index,Circom_CalcWit* ctx);
void Main_28_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather);
void Main_28_run(uint ctx_index,Circom_CalcWit* ctx);
Circom_TemplateFunction _functionTable[29] = { 
ToBits_0_run,
XorWordConst_1_run,
Blake3Permute_2_run,
Bits34_3_run,
Bits33_4_run,
RotRight_5_run,
RotRightWord_6_run,
RotRight_7_run,
RotRightWord_8_run,
RotRight_9_run,
RotRightWord_10_run,
RotRight_11_run,
RotRightWord_12_run,
XOR2_13_run,
XorWord2_14_run,
Blake3G_15_run,
Blake3G_16_run,
Blake3G_17_run,
Blake3G_18_run,
Blake3G_19_run,
Blake3G_20_run,
Blake3G_21_run,
Blake3G_22_run,
Blake3Round_23_run,
XOR3_24_run,
XorWord3_25_run,
Blake3Compress_26_run,
Blake3Bytes_27_run,
Main_28_run };
Circom_TemplateFunction _functionTableParallel[29] = { 
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL };
uint get_main_input_signal_start() {return 33;}

uint get_main_input_signal_no() {return 32;}

uint get_total_signal_no() {return 81557;}

uint get_number_of_components() {return 9111;}

uint get_size_of_input_hashmap() {return 256;}

uint get_size_of_witness() {return 38788;}

uint get_size_of_constants() {return 30;}

uint get_size_of_io_map() {return 8;}

uint get_size_of_bus_field_map() {return 0;}

void release_memory_component(Circom_CalcWit* ctx, uint pos) {{

if (pos != 0){{

if(ctx->componentMemory[pos].subcomponents)
delete []ctx->componentMemory[pos].subcomponents;

if(ctx->componentMemory[pos].subcomponentsParallel)
delete []ctx->componentMemory[pos].subcomponentsParallel;

if(ctx->componentMemory[pos].outputIsSet)
delete []ctx->componentMemory[pos].outputIsSet;

if(ctx->componentMemory[pos].mutexes)
delete []ctx->componentMemory[pos].mutexes;

if(ctx->componentMemory[pos].cvs)
delete []ctx->componentMemory[pos].cvs;

if(ctx->componentMemory[pos].sbct)
delete []ctx->componentMemory[pos].sbct;

}}


}}


// function declarations
// template declarations
void ToBits_0_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 0;
ctx->componentMemory[coffset].templateName = "ToBits";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void ToBits_0_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[3];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[0]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 148
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)];
// load src
Fr_shr(&expaux[1],&signalValues[mySignalStart + 32],&lvar[2]); // line circom 149
Fr_band(&expaux[0],&expaux[1],&circuitConstants[2]); // line circom 149
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
Fr_sub(&expaux[2],&circuitConstants[2],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)]); // line circom 150
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)],&expaux[2]); // line circom 150
{{
Fr_eq(&expaux[0],&expaux[1],&circuitConstants[1]); // line circom 150
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 150. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_shl(&expaux[2],&circuitConstants[2],&lvar[2]); // line circom 151
Fr_mul(&expaux[1],&expaux[2],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)]); // line circom 151
Fr_add(&expaux[0],&lvar[1],&expaux[1]); // line circom 151
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 148
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 148
}
{
{{
Fr_eq(&expaux[0],&signalValues[mySignalStart + 32],&lvar[1]); // line circom 154
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 154. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void XorWordConst_1_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 1;
ctx->componentMemory[coffset].templateName = "XorWordConst";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[1]{0};
}

void XorWordConst_1_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[5];
FrElement lvar[6];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[0]);
}
{
std::string new_cmp_name = "tb";
ToBits_0_create(mySignalStart+34,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 33]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[3],&circuitConstants[0]); // line circom 130
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &lvar[4];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + ((1 * Fr_toInt(&lvar[3])) + 0)]);
}
{
PFrElement aux_dest = &lvar[5];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[3])) + 0)];
// load src
Fr_add(&expaux[1],&lvar[4],&circuitConstants[1]); // line circom 133
Fr_mul(&expaux[3],&circuitConstants[3],&lvar[4]); // line circom 133
Fr_mul(&expaux[2],&expaux[3],&circuitConstants[1]); // line circom 133
Fr_sub(&expaux[0],&expaux[1],&expaux[2]); // line circom 133
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[3]); // line circom 134
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[3])) + 0)],&expaux[2]); // line circom 134
Fr_add(&expaux[0],&lvar[2],&expaux[1]); // line circom 134
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
Fr_add(&expaux[0],&lvar[3],&circuitConstants[2]); // line circom 130
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[3],&circuitConstants[0]); // line circom 130
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[2]);
}
for (uint i = 0; i < 1; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3Permute_2_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 2;
ctx->componentMemory[coffset].templateName = "Blake3Permute";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 16;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void Blake3Permute_2_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[2];
FrElement lvar[17];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[5];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[6];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[7];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[9];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[10];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[11];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[12];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[13];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[14];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[15];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[3]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[7]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[4]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[11]);
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[8]);
}
{
PFrElement aux_dest = &lvar[5];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[6];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[5]);
}
{
PFrElement aux_dest = &lvar[7];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[14]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[2]);
}
{
PFrElement aux_dest = &lvar[9];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[12]);
}
{
PFrElement aux_dest = &lvar[10];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[13]);
}
{
PFrElement aux_dest = &lvar[11];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[6]);
}
{
PFrElement aux_dest = &lvar[12];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[10]);
}
{
PFrElement aux_dest = &lvar[13];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[15]);
}
{
PFrElement aux_dest = &lvar[14];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[16]);
}
{
PFrElement aux_dest = &lvar[15];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[9]);
}
{
PFrElement aux_dest = &lvar[16];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[16],&circuitConstants[17]); // line circom 24
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[16])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[((1 * Fr_toInt(&lvar[16])) + 0)])) + 16)]);
}
{
PFrElement aux_dest = &lvar[16];
// load src
Fr_add(&expaux[0],&lvar[16],&circuitConstants[2]); // line circom 24
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[16],&circuitConstants[17]); // line circom 24
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Bits34_3_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 3;
ctx->componentMemory[coffset].templateName = "Bits34";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void Bits34_3_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[5];
FrElement lvar[2];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[1],&circuitConstants[0]); // line circom 190
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)];
// load src
Fr_shr(&expaux[1],&signalValues[mySignalStart + 33],&lvar[1]); // line circom 191
Fr_band(&expaux[0],&expaux[1],&circuitConstants[2]); // line circom 191
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
Fr_sub(&expaux[2],&circuitConstants[2],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)]); // line circom 192
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)],&expaux[2]); // line circom 192
{{
Fr_eq(&expaux[0],&expaux[1],&circuitConstants[1]); // line circom 192
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 192. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
PFrElement aux_dest = &lvar[0];
// load src
Fr_shl(&expaux[2],&circuitConstants[2],&lvar[1]); // line circom 193
Fr_mul(&expaux[1],&expaux[2],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)]); // line circom 193
Fr_add(&expaux[0],&lvar[0],&expaux[1]); // line circom 193
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_add(&expaux[0],&lvar[1],&circuitConstants[2]); // line circom 190
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[1],&circuitConstants[0]); // line circom 190
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
Fr_shr(&expaux[1],&signalValues[mySignalStart + 33],&circuitConstants[0]); // line circom 196
Fr_band(&expaux[0],&expaux[1],&circuitConstants[2]); // line circom 196
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
Fr_shr(&expaux[1],&signalValues[mySignalStart + 33],&circuitConstants[18]); // line circom 197
Fr_band(&expaux[0],&expaux[1],&circuitConstants[2]); // line circom 197
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
Fr_sub(&expaux[2],&circuitConstants[2],&signalValues[mySignalStart + 34]); // line circom 198
Fr_mul(&expaux[1],&signalValues[mySignalStart + 34],&expaux[2]); // line circom 198
{{
Fr_eq(&expaux[0],&expaux[1],&circuitConstants[1]); // line circom 198
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 198. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
Fr_sub(&expaux[2],&circuitConstants[2],&signalValues[mySignalStart + 35]); // line circom 199
Fr_mul(&expaux[1],&signalValues[mySignalStart + 35],&expaux[2]); // line circom 199
{{
Fr_eq(&expaux[0],&expaux[1],&circuitConstants[1]); // line circom 199
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 199. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
Fr_mul(&expaux[3],&circuitConstants[19],&signalValues[mySignalStart + 34]); // line circom 201
Fr_add(&expaux[2],&lvar[0],&expaux[3]); // line circom 201
Fr_mul(&expaux[3],&circuitConstants[20],&signalValues[mySignalStart + 35]); // line circom 201
Fr_add(&expaux[1],&expaux[2],&expaux[3]); // line circom 201
{{
Fr_eq(&expaux[0],&signalValues[mySignalStart + 33],&expaux[1]); // line circom 201
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 201. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[0]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Bits33_4_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 4;
ctx->componentMemory[coffset].templateName = "Bits33";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void Bits33_4_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[2];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[1],&circuitConstants[0]); // line circom 167
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)];
// load src
Fr_shr(&expaux[1],&signalValues[mySignalStart + 33],&lvar[1]); // line circom 168
Fr_band(&expaux[0],&expaux[1],&circuitConstants[2]); // line circom 168
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
Fr_sub(&expaux[2],&circuitConstants[2],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)]); // line circom 169
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)],&expaux[2]); // line circom 169
{{
Fr_eq(&expaux[0],&expaux[1],&circuitConstants[1]); // line circom 169
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 169. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
PFrElement aux_dest = &lvar[0];
// load src
Fr_shl(&expaux[2],&circuitConstants[2],&lvar[1]); // line circom 170
Fr_mul(&expaux[1],&expaux[2],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[1])) + 0)]); // line circom 170
Fr_add(&expaux[0],&lvar[0],&expaux[1]); // line circom 170
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_add(&expaux[0],&lvar[1],&circuitConstants[2]); // line circom 167
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[1],&circuitConstants[0]); // line circom 167
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
Fr_shr(&expaux[1],&signalValues[mySignalStart + 33],&circuitConstants[0]); // line circom 173
Fr_band(&expaux[0],&expaux[1],&circuitConstants[2]); // line circom 173
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
Fr_sub(&expaux[2],&circuitConstants[2],&signalValues[mySignalStart + 34]); // line circom 174
Fr_mul(&expaux[1],&signalValues[mySignalStart + 34],&expaux[2]); // line circom 174
{{
Fr_eq(&expaux[0],&expaux[1],&circuitConstants[1]); // line circom 174
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 174. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
Fr_mul(&expaux[2],&circuitConstants[19],&signalValues[mySignalStart + 34]); // line circom 176
Fr_add(&expaux[1],&lvar[0],&expaux[2]); // line circom 176
{{
Fr_eq(&expaux[0],&signalValues[mySignalStart + 33],&expaux[1]); // line circom 176
}}
if (!Fr_isTrue(&expaux[0])) std::cout << "Failed assert in template/function " << myTemplateName << " line 176. " <<  "Followed trace of components: " << ctx->getTrace(myId) << std::endl;
assert(Fr_isTrue(&expaux[0]));
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[0]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRight_5_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 5;
ctx->componentMemory[coffset].templateName = "RotRight";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 32;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void RotRight_5_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[3];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[17]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)];
// load src
Fr_add(&expaux[1],&lvar[2],&circuitConstants[17]); // line circom 264
Fr_mod(&expaux[0],&expaux[1],&circuitConstants[0]); // line circom 264
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&expaux[0])) + 33)]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[2]); // line circom 265
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)],&expaux[2]); // line circom 265
Fr_add(&expaux[0],&lvar[1],&expaux[1]); // line circom 265
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 263
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[1]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRightWord_6_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 6;
ctx->componentMemory[coffset].templateName = "RotRightWord";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[2]{0};
}

void RotRightWord_6_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[1];
FrElement lvar[1];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[17]);
}
{
std::string new_cmp_name = "tb";
ToBits_0_create(mySignalStart+67,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "rot";
RotRight_5_create(mySignalStart+2,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 0+ctx_index+1;
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 1]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copyn(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 0],32);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 32;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRight_5_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
for (uint i = 0; i < 2; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRight_7_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 7;
ctx->componentMemory[coffset].templateName = "RotRight";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 32;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void RotRight_7_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[3];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[13]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)];
// load src
Fr_add(&expaux[1],&lvar[2],&circuitConstants[13]); // line circom 264
Fr_mod(&expaux[0],&expaux[1],&circuitConstants[0]); // line circom 264
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&expaux[0])) + 33)]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[2]); // line circom 265
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)],&expaux[2]); // line circom 265
Fr_add(&expaux[0],&lvar[1],&expaux[1]); // line circom 265
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 263
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[1]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRightWord_8_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 8;
ctx->componentMemory[coffset].templateName = "RotRightWord";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[2]{0};
}

void RotRightWord_8_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[1];
FrElement lvar[1];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[13]);
}
{
std::string new_cmp_name = "tb";
ToBits_0_create(mySignalStart+67,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "rot";
RotRight_7_create(mySignalStart+2,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 0+ctx_index+1;
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 1]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copyn(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 0],32);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 32;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRight_7_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
for (uint i = 0; i < 2; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRight_9_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 9;
ctx->componentMemory[coffset].templateName = "RotRight";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 32;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void RotRight_9_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[3];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[9]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)];
// load src
Fr_add(&expaux[1],&lvar[2],&circuitConstants[9]); // line circom 264
Fr_mod(&expaux[0],&expaux[1],&circuitConstants[0]); // line circom 264
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&expaux[0])) + 33)]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[2]); // line circom 265
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)],&expaux[2]); // line circom 265
Fr_add(&expaux[0],&lvar[1],&expaux[1]); // line circom 265
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 263
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[1]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRightWord_10_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 10;
ctx->componentMemory[coffset].templateName = "RotRightWord";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[2]{0};
}

void RotRightWord_10_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[1];
FrElement lvar[1];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[9]);
}
{
std::string new_cmp_name = "tb";
ToBits_0_create(mySignalStart+67,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "rot";
RotRight_9_create(mySignalStart+2,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 0+ctx_index+1;
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 1]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copyn(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 0],32);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 32;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRight_9_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
for (uint i = 0; i < 2; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRight_11_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 11;
ctx->componentMemory[coffset].templateName = "RotRight";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 32;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void RotRight_11_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[3];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[8]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)];
// load src
Fr_add(&expaux[1],&lvar[2],&circuitConstants[8]); // line circom 264
Fr_mod(&expaux[0],&expaux[1],&circuitConstants[0]); // line circom 264
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&expaux[0])) + 33)]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[2]); // line circom 265
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)],&expaux[2]); // line circom 265
Fr_add(&expaux[0],&lvar[1],&expaux[1]); // line circom 265
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 263
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 263
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[1]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void RotRightWord_12_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 12;
ctx->componentMemory[coffset].templateName = "RotRightWord";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 1;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[2]{0};
}

void RotRightWord_12_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[1];
FrElement lvar[1];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[8]);
}
{
std::string new_cmp_name = "tb";
ToBits_0_create(mySignalStart+67,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "rot";
RotRight_11_create(mySignalStart+2,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 0+ctx_index+1;
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 1]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copyn(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 0],32);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 32;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRight_11_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
for (uint i = 0; i < 2; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void XOR2_13_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 13;
ctx->componentMemory[coffset].templateName = "XOR2";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 2;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void XOR2_13_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[5];
FrElement lvar[0];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 1],&signalValues[mySignalStart + 2]); // line circom 39
Fr_mul(&expaux[3],&circuitConstants[3],&signalValues[mySignalStart + 1]); // line circom 39
Fr_mul(&expaux[2],&expaux[3],&signalValues[mySignalStart + 2]); // line circom 39
Fr_sub(&expaux[0],&expaux[1],&expaux[2]); // line circom 39
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void XorWord2_14_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 14;
ctx->componentMemory[coffset].templateName = "XorWord2";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 2;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[34]{0};
}

void XorWord2_14_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[3];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[0]);
}
{
std::string new_cmp_name = "tb_x";
ToBits_0_create(mySignalStart+35,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "tb_y";
ToBits_0_create(mySignalStart+68,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
uint aux_create = 2;
int aux_cmp_num = 2+ctx_index+1;
uint csoffset = mySignalStart+101;
uint aux_dimensions[1] = {32};
for (uint i = 0; i < 32; i++) {
std::string new_cmp_name = "xor"+ctx->generate_position_array(aux_dimensions, 1, i);
XOR2_13_create(csoffset,aux_cmp_num,ctx,new_cmp_name,myId);
mySubcomponents[aux_create+ i] = aux_cmp_num;
csoffset += 3 ;
aux_cmp_num += 1;
}
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 1]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 2]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 74
while(Fr_isTrue(&expaux[0])){
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[2])) + 2);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + ((1 * Fr_toInt(&lvar[2])) + 0)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XOR2_13_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[2])) + 2);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + ((1 * Fr_toInt(&lvar[2])) + 0)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XOR2_13_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 3)];
// load src
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[2])) + 2);
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[2])) + 2);
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[((1 * Fr_toInt(&lvar[2])) + 2)]].signalStart + 0]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[2]); // line circom 79
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 3)],&expaux[2]); // line circom 79
Fr_add(&expaux[0],&lvar[1],&expaux[1]); // line circom 79
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 74
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 74
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
// end load src
Fr_copy(aux_dest,&lvar[1]);
}
for (uint i = 0; i < 34; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_15_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 15;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_15_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[5]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[9]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[13]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[1]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[5]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[9]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[13]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 16],&signalValues[mySignalStart + 20]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 28]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 24],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 20]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 4];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 8];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 12];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_16_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 16;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_16_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[2]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[6]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[10]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[14]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[2]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[6]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[10]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[14]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 17],&signalValues[mySignalStart + 21]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 29]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 25],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 21]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 5];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 9];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 13];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_17_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 17;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_17_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[3]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[7]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[11]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[15]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[3]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[7]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[11]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[15]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 18],&signalValues[mySignalStart + 22]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 30]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 26],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 22]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 6];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 10];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 14];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_18_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 18;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_18_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[4]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[8]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[12]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[16]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[4]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[8]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[12]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[16]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 19],&signalValues[mySignalStart + 23]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 31]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 27],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 23]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 3];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 7];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 11];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 15];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_19_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 19;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_19_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[6]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[11]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[16]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[1]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[6]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[11]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[16]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 16],&signalValues[mySignalStart + 21]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 31]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 26],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 21]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 5];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 10];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 15];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_20_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 20;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_20_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[2]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[7]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[12]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[13]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[2]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[7]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[12]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[13]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 17],&signalValues[mySignalStart + 22]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 28]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 27],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 22]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 6];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 11];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 12];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_21_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 21;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_21_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[3]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[8]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[9]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[14]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[3]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[8]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[9]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[14]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 18],&signalValues[mySignalStart + 23]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 29]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 24],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 23]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 7];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 8];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 13];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3G_22_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 22;
ctx->componentMemory[coffset].templateName = "Blake3G";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 18;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[12]{0};
}

void Blake3G_22_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[6];
FrElement lvar[5];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[4]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[5]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[10]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[15]);
}
{
std::string new_cmp_name = "add1";
Bits34_3_create(mySignalStart+42,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "add2";
Bits33_4_create(mySignalStart+78,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "add3";
Bits34_3_create(mySignalStart+113,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
std::string new_cmp_name = "add4";
Bits33_4_create(mySignalStart+149,3+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 3+ctx_index+1;
}
{
std::string new_cmp_name = "rot1";
RotRightWord_6_create(mySignalStart+184,4+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 4+ctx_index+1;
}
{
std::string new_cmp_name = "rot2";
RotRightWord_8_create(mySignalStart+284,7+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 7+ctx_index+1;
}
{
std::string new_cmp_name = "rot3";
RotRightWord_10_create(mySignalStart+384,10+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 10+ctx_index+1;
}
{
std::string new_cmp_name = "rot4";
RotRightWord_12_create(mySignalStart+484,13+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 13+ctx_index+1;
}
{
std::string new_cmp_name = "xor1";
XorWord2_14_create(mySignalStart+584,16+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 16+ctx_index+1;
}
{
std::string new_cmp_name = "xor2";
XorWord2_14_create(mySignalStart+781,51+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[9] = 51+ctx_index+1;
}
{
std::string new_cmp_name = "xor3";
XorWord2_14_create(mySignalStart+978,86+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[10] = 86+ctx_index+1;
}
{
std::string new_cmp_name = "xor4";
XorWord2_14_create(mySignalStart+1175,121+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[11] = 121+ctx_index+1;
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
while(Fr_isTrue(&expaux[0])){
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[4]); // line circom 295
Fr_neq(&expaux[4],&lvar[4],&circuitConstants[5]); // line circom 295
Fr_land(&expaux[2],&expaux[3],&expaux[4]); // line circom 295
Fr_neq(&expaux[3],&lvar[4],&circuitConstants[10]); // line circom 295
Fr_land(&expaux[1],&expaux[2],&expaux[3]); // line circom 295
Fr_neq(&expaux[2],&lvar[4],&circuitConstants[15]); // line circom 295
Fr_land(&expaux[0],&expaux[1],&expaux[2]); // line circom 295
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[4])) + 16)]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 294
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[17]); // line circom 294
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 19],&signalValues[mySignalStart + 20]); // line circom 329
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 32]); // line circom 329
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 34];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 30]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 8;
cmp_index_ref_load = 8;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[8]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_6_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 40];
// load src
cmp_index_ref_load = 4;
cmp_index_ref_load = 4;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[4]].signalStart + 0]);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 25],&signalValues[mySignalStart + 40]); // line circom 339
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 38];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 20]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 9;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 38]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 9;
cmp_index_ref_load = 9;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[9]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_8_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 36];
// load src
cmp_index_ref_load = 5;
cmp_index_ref_load = 5;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[5]].signalStart + 0]);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[1],&signalValues[mySignalStart + 34],&signalValues[mySignalStart + 36]); // line circom 349
Fr_add(&expaux[0],&expaux[1],&signalValues[mySignalStart + 33]); // line circom 349
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits34_3_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 35];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 40]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 10;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 10;
cmp_index_ref_load = 10;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[10]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_10_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 41];
// load src
cmp_index_ref_load = 6;
cmp_index_ref_load = 6;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[6]].signalStart + 0]);
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
Fr_add(&expaux[0],&signalValues[mySignalStart + 38],&signalValues[mySignalStart + 41]); // line circom 359
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Bits33_4_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 39];
// load src
cmp_index_ref_load = 3;
cmp_index_ref_load = 3;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[3]].signalStart + 32]);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 36]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 11;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWord2_14_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 11;
cmp_index_ref_load = 11;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[11]].signalStart + 0]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
RotRightWord_12_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 37];
// load src
cmp_index_ref_load = 7;
cmp_index_ref_load = 7;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[7]].signalStart + 0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 3];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 4];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 37]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 9];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 39]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 14];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 41]);
}
for (uint i = 0; i < 12; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3Round_23_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 23;
ctx->componentMemory[coffset].templateName = "Blake3Round";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 32;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[9]{0};
}

void Blake3Round_23_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[2];
FrElement lvar[1];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
std::string new_cmp_name = "perm";
Blake3Permute_2_create(mySignalStart+11168,1256+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 1256+ctx_index+1;
}
{
std::string new_cmp_name = "GS[0]";
Blake3G_15_create(mySignalStart+192,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "GS[1]";
Blake3G_16_create(mySignalStart+1564,157+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 157+ctx_index+1;
}
{
std::string new_cmp_name = "GS[2]";
Blake3G_17_create(mySignalStart+2936,314+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[3] = 314+ctx_index+1;
}
{
std::string new_cmp_name = "GS[3]";
Blake3G_18_create(mySignalStart+4308,471+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[4] = 471+ctx_index+1;
}
{
std::string new_cmp_name = "GS[4]";
Blake3G_19_create(mySignalStart+5680,628+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[5] = 628+ctx_index+1;
}
{
std::string new_cmp_name = "GS[5]";
Blake3G_20_create(mySignalStart+7052,785+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[6] = 785+ctx_index+1;
}
{
std::string new_cmp_name = "GS[6]";
Blake3G_21_create(mySignalStart+8424,942+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[7] = 942+ctx_index+1;
}
{
std::string new_cmp_name = "GS[7]";
Blake3G_22_create(mySignalStart+9796,1099+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[8] = 1099+ctx_index+1;
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 16];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + 32],16);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 16;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Blake3Permute_2_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 48];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + 16],16);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 0]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 1]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 2]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 3]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 4]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 3;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 5]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 6]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 4;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 7]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 8]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 5;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 9]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 10]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 6;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 11]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 12]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 7;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 13]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[2].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 14]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = 8;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[3].offset];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 15]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[0],&circuitConstants[9]); // line circom 403
while(Fr_isTrue(&expaux[0])){
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[0])) + 1);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId].defs[1].offset];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + ((16 * Fr_toInt(&lvar[0])) + 48)],16);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 16)){
(*_functionTable[ctx->componentMemory[mySubcomponents[cmp_index_ref]].templateId])(mySubcomponents[cmp_index_ref],ctx);

}
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((16 * (Fr_toInt(&lvar[0]) + 1)) + 48)];
// load src
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[0])) + 1);
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[0])) + 1);
// end load src
Fr_copyn(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[((1 * Fr_toInt(&lvar[0])) + 1)]].signalStart + ctx->templateInsId2IOSignalInfo[ctx->componentMemory[mySubcomponents[((1 * Fr_toInt(&lvar[0])) + 1)]].templateId].defs[0].offset],16);
}
{
PFrElement aux_dest = &lvar[0];
// load src
Fr_add(&expaux[0],&lvar[0],&circuitConstants[2]); // line circom 403
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[0],&circuitConstants[9]); // line circom 403
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + 176],16);
}
for (uint i = 0; i < 9; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void XOR3_24_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 24;
ctx->componentMemory[coffset].templateName = "XOR3";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 3;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[0];
}

void XOR3_24_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[10];
FrElement lvar[0];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &signalValues[mySignalStart + 4];
// load src
Fr_mul(&expaux[0],&signalValues[mySignalStart + 2],&signalValues[mySignalStart + 3]); // line circom 51
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
Fr_mul(&expaux[8],&circuitConstants[3],&signalValues[mySignalStart + 2]); // line circom 52
Fr_sub(&expaux[6],&circuitConstants[2],&expaux[8]); // line circom 52
Fr_mul(&expaux[7],&circuitConstants[3],&signalValues[mySignalStart + 3]); // line circom 52
Fr_sub(&expaux[5],&expaux[6],&expaux[7]); // line circom 52
Fr_mul(&expaux[6],&circuitConstants[5],&signalValues[mySignalStart + 4]); // line circom 52
Fr_add(&expaux[4],&expaux[5],&expaux[6]); // line circom 52
Fr_mul(&expaux[3],&signalValues[mySignalStart + 1],&expaux[4]); // line circom 52
Fr_add(&expaux[2],&expaux[3],&signalValues[mySignalStart + 2]); // line circom 52
Fr_add(&expaux[1],&expaux[2],&signalValues[mySignalStart + 3]); // line circom 52
Fr_mul(&expaux[2],&circuitConstants[3],&signalValues[mySignalStart + 4]); // line circom 52
Fr_sub(&expaux[0],&expaux[1],&expaux[2]); // line circom 52
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
for (uint i = 0; i < 0; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void XorWord3_25_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 25;
ctx->componentMemory[coffset].templateName = "XorWord3";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 3;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[35]{0};
}

void XorWord3_25_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[3];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[0]);
}
{
std::string new_cmp_name = "tb_x";
ToBits_0_create(mySignalStart+36,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
std::string new_cmp_name = "tb_y";
ToBits_0_create(mySignalStart+69,1+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 1+ctx_index+1;
}
{
std::string new_cmp_name = "tb_z";
ToBits_0_create(mySignalStart+102,2+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 2+ctx_index+1;
}
{
uint aux_create = 3;
int aux_cmp_num = 3+ctx_index+1;
uint csoffset = mySignalStart+135;
uint aux_dimensions[1] = {32};
for (uint i = 0; i < 32; i++) {
std::string new_cmp_name = "xor"+ctx->generate_position_array(aux_dimensions, 1, i);
XOR3_24_create(csoffset,aux_cmp_num,ctx,new_cmp_name,myId);
mySubcomponents[aux_create+ i] = aux_cmp_num;
csoffset += 5 ;
aux_cmp_num += 1;
}
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 33]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 34]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 35]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 106
while(Fr_isTrue(&expaux[0])){
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[2])) + 3);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 1];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + ((1 * Fr_toInt(&lvar[2])) + 0)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XOR3_24_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[2])) + 3);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 2];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + ((1 * Fr_toInt(&lvar[2])) + 0)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XOR3_24_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[2])) + 3);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 3];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + ((1 * Fr_toInt(&lvar[2])) + 0)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XOR3_24_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)];
// load src
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[2])) + 3);
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[2])) + 3);
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[((1 * Fr_toInt(&lvar[2])) + 3)]].signalStart + 0]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[2]); // line circom 112
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 0)],&expaux[2]); // line circom 112
Fr_add(&expaux[0],&lvar[1],&expaux[1]); // line circom 112
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 106
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[0]); // line circom 106
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&lvar[1]);
}
for (uint i = 0; i < 35; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3Compress_26_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 26;
ctx->componentMemory[coffset].templateName = "Blake3Compress";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 27;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[18]{0};
}

void Blake3Compress_26_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[2];
FrElement lvar[9];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
std::string new_cmp_name = "xor_t0";
XorWordConst_1_create(mySignalStart+81006,9096+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 9096+ctx_index+1;
}
{
std::string new_cmp_name = "xor_t1";
XorWordConst_1_create(mySignalStart+81073,9098+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[1] = 9098+ctx_index+1;
}
{
std::string new_cmp_name = "xor_f";
XorWordConst_1_create(mySignalStart+80939,9094+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[2] = 9094+ctx_index+1;
}
{
uint aux_create = 3;
int aux_cmp_num = 288+ctx_index+1;
uint csoffset = mySignalStart+2539;
uint aux_dimensions[1] = {7};
for (uint i = 0; i < 7; i++) {
std::string new_cmp_name = "rounds"+ctx->generate_position_array(aux_dimensions, 1, i);
Blake3Round_23_create(csoffset,aux_cmp_num,ctx,new_cmp_name,myId);
mySubcomponents[aux_create+ i] = aux_cmp_num;
csoffset += 11200 ;
aux_cmp_num += 1258;
}
}
{
uint aux_create = 10;
int aux_cmp_num = 0+ctx_index+1;
uint csoffset = mySignalStart+179;
uint aux_dimensions[1] = {8};
for (uint i = 0; i < 8; i++) {
std::string new_cmp_name = "fin"+ctx->generate_position_array(aux_dimensions, 1, i);
XorWord3_25_create(csoffset,aux_cmp_num,ctx,new_cmp_name,myId);
mySubcomponents[aux_create+ i] = aux_cmp_num;
csoffset += 295 ;
aux_cmp_num += 36;
}
}
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[5];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[6];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[7];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[21]);
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[22]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[23]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[24]);
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[25]);
}
{
PFrElement aux_dest = &lvar[5];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[26]);
}
{
PFrElement aux_dest = &lvar[6];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[27]);
}
{
PFrElement aux_dest = &lvar[7];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[28]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[9]); // line circom 429
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[8])) + 35)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[8])) + 8)]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * (Fr_toInt(&lvar[8]) + 8)) + 35)];
// load src
// end load src
Fr_copy(aux_dest,&lvar[((1 * Fr_toInt(&lvar[8])) + 0)]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
Fr_add(&expaux[0],&lvar[8],&circuitConstants[2]); // line circom 429
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[9]); // line circom 429
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 47]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWordConst_1_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 1;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 48]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWordConst_1_run(mySubcomponents[cmp_index_ref],ctx);
}
{
uint cmp_index_ref = 2;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 49]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
XorWordConst_1_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[13]); // line circom 446
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((0 + (1 * Fr_toInt(&lvar[8]))) + 51)];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[8])) + 35)]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
Fr_add(&expaux[0],&lvar[8],&circuitConstants[2]); // line circom 446
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[13]); // line circom 446
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 63];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 32]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 64];
// load src
cmp_index_ref_load = 1;
cmp_index_ref_load = 1;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[1]].signalStart + 32]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 65];
// load src
cmp_index_ref_load = 2;
cmp_index_ref_load = 2;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[2]].signalStart + 32]);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 66];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + 50]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[8]); // line circom 456
while(Fr_isTrue(&expaux[0])){
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[8])) + 3);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + 16],16);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 16)){
Blake3Round_23_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[8])) + 3);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 16];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + ((16 * Fr_toInt(&lvar[8])) + 51)],16);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 16)){
Blake3Round_23_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((16 * (Fr_toInt(&lvar[8]) + 1)) + 51)];
// load src
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[8])) + 3);
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[8])) + 3);
// end load src
Fr_copyn(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[((1 * Fr_toInt(&lvar[8])) + 3)]].signalStart + 0],16);
}
{
PFrElement aux_dest = &lvar[8];
// load src
Fr_add(&expaux[0],&lvar[8],&circuitConstants[2]); // line circom 456
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[8]); // line circom 456
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[9]); // line circom 465
while(Fr_isTrue(&expaux[0])){
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[8])) + 10);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[8])) + 8)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XorWord3_25_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[8])) + 10);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 34];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((112 + (1 * Fr_toInt(&lvar[8]))) + 51)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XorWord3_25_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[8])) + 10);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 35];
// load src
// end load src
Fr_copy(aux_dest,&signalValues[mySignalStart + ((112 + (1 * (Fr_toInt(&lvar[8]) + 8))) + 51)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
XorWord3_25_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[8])) + 0)];
// load src
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[8])) + 10);
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[8])) + 10);
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[((1 * Fr_toInt(&lvar[8])) + 10)]].signalStart + 32]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
Fr_add(&expaux[0],&lvar[8],&circuitConstants[2]); // line circom 465
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[8],&circuitConstants[9]); // line circom 465
}
for (uint i = 0; i < 18; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Blake3Bytes_27_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 27;
ctx->componentMemory[coffset].templateName = "Blake3Bytes";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 32;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[9]{0};
}

void Blake3Bytes_27_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[4];
FrElement lvar[16];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[0]);
}
{
std::string new_cmp_name = "compress";
Blake3Compress_26_create(mySignalStart+88,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
uint aux_create = 1;
int aux_cmp_num = 9101+ctx_index+1;
uint csoffset = mySignalStart+81228;
uint aux_dimensions[1] = {8};
for (uint i = 0; i < 8; i++) {
std::string new_cmp_name = "tbs"+ctx->generate_position_array(aux_dimensions, 1, i);
ToBits_0_create(csoffset,aux_cmp_num,ctx,new_cmp_name,myId);
mySubcomponents[aux_create+ i] = aux_cmp_num;
csoffset += 33 ;
aux_cmp_num += 1;
}
}
{
PFrElement aux_dest = &lvar[1];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[2]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[17]); // line circom 490
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[5]); // line circom 492
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &lvar[5];
// load src
Fr_mul(&expaux[1],&lvar[2],&circuitConstants[5]); // line circom 493
Fr_add(&expaux[0],&expaux[1],&lvar[4]); // line circom 493
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[5],&circuitConstants[0]); // line circom 494
if(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &lvar[3];
// load src
Fr_pow(&expaux[2],&circuitConstants[29],&lvar[4]); // line circom 495
Fr_mul(&expaux[1],&signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[5])) + 32)],&expaux[2]); // line circom 495
Fr_add(&expaux[0],&lvar[3],&expaux[1]); // line circom 495
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
}
{
PFrElement aux_dest = &lvar[4];
// load src
Fr_add(&expaux[0],&lvar[4],&circuitConstants[2]); // line circom 492
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[4],&circuitConstants[5]); // line circom 492
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[2])) + 64)];
// load src
// end load src
Fr_copy(aux_dest,&lvar[3]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
Fr_add(&expaux[0],&lvar[2],&circuitConstants[2]); // line circom 490
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[2],&circuitConstants[17]); // line circom 490
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[5];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[6];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[7];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[9];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[2];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[21]);
}
{
PFrElement aux_dest = &lvar[3];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[22]);
}
{
PFrElement aux_dest = &lvar[4];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[23]);
}
{
PFrElement aux_dest = &lvar[5];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[24]);
}
{
PFrElement aux_dest = &lvar[6];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[25]);
}
{
PFrElement aux_dest = &lvar[7];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[26]);
}
{
PFrElement aux_dest = &lvar[8];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[27]);
}
{
PFrElement aux_dest = &lvar[9];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[28]);
}
{
PFrElement aux_dest = &lvar[10];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[10],&circuitConstants[9]); // line circom 506
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[10])) + 80)];
// load src
// end load src
Fr_copy(aux_dest,&lvar[((1 * Fr_toInt(&lvar[10])) + 2)]);
}
{
PFrElement aux_dest = &lvar[10];
// load src
Fr_add(&expaux[0],&lvar[10],&circuitConstants[2]); // line circom 506
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[10],&circuitConstants[9]); // line circom 506
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 8];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + 80],8);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 8;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 16];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + 64],16);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 16;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 33];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
// no need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter > 0);
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 34];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[2]);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Blake3Compress_26_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &lvar[10];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[10],&circuitConstants[9]); // line circom 520
while(Fr_isTrue(&expaux[0])){
{
uint cmp_index_ref = ((1 * Fr_toInt(&lvar[10])) + 1);
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copy(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + ((1 * Fr_toInt(&lvar[10])) + 0)]);
}
// run sub component if needed
if(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 1)){
ToBits_0_run(mySubcomponents[cmp_index_ref],ctx);

}
}
{
PFrElement aux_dest = &lvar[10];
// load src
Fr_add(&expaux[0],&lvar[10],&circuitConstants[2]); // line circom 520
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[10],&circuitConstants[9]); // line circom 520
}
{
PFrElement aux_dest = &lvar[10];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[10],&circuitConstants[0]); // line circom 526
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &lvar[11];
// load src
Fr_idiv(&expaux[0],&lvar[10],&circuitConstants[5]); // line circom 527
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[12];
// load src
Fr_mod(&expaux[0],&lvar[10],&circuitConstants[5]); // line circom 528
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[13];
// load src
Fr_mul(&expaux[0],&lvar[12],&circuitConstants[9]); // line circom 529
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[14];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
{
PFrElement aux_dest = &lvar[15];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[1]);
}
Fr_lt(&expaux[0],&lvar[15],&circuitConstants[9]); // line circom 531
while(Fr_isTrue(&expaux[0])){
{
PFrElement aux_dest = &lvar[14];
// load src
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[11])) + 1);
cmp_index_ref_load = ((1 * Fr_toInt(&lvar[11])) + 1);
Fr_pow(&expaux[2],&circuitConstants[3],&lvar[15]); // line circom 532
Fr_mul(&expaux[1],&ctx->signalValues[ctx->componentMemory[mySubcomponents[((1 * Fr_toInt(&lvar[11])) + 1)]].signalStart + ((1 * (Fr_toInt(&lvar[13]) + Fr_toInt(&lvar[15]))) + 0)],&expaux[2]); // line circom 532
Fr_add(&expaux[0],&lvar[14],&expaux[1]); // line circom 532
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
{
PFrElement aux_dest = &lvar[15];
// load src
Fr_add(&expaux[0],&lvar[15],&circuitConstants[2]); // line circom 531
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[15],&circuitConstants[9]); // line circom 531
}
{
PFrElement aux_dest = &signalValues[mySignalStart + ((1 * Fr_toInt(&lvar[10])) + 0)];
// load src
// end load src
Fr_copy(aux_dest,&lvar[14]);
}
{
PFrElement aux_dest = &lvar[10];
// load src
Fr_add(&expaux[0],&lvar[10],&circuitConstants[2]); // line circom 526
// end load src
Fr_copy(aux_dest,&expaux[0]);
}
Fr_lt(&expaux[0],&lvar[10],&circuitConstants[0]); // line circom 526
}
for (uint i = 0; i < 9; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void Main_28_create(uint soffset,uint coffset,Circom_CalcWit* ctx,std::string componentName,uint componentFather){
ctx->componentMemory[coffset].templateId = 28;
ctx->componentMemory[coffset].templateName = "Main";
ctx->componentMemory[coffset].signalStart = soffset;
ctx->componentMemory[coffset].inputCounter = 32;
ctx->componentMemory[coffset].componentName = componentName;
ctx->componentMemory[coffset].idFather = componentFather;
ctx->componentMemory[coffset].subcomponents = new uint[1]{0};
}

void Main_28_run(uint ctx_index,Circom_CalcWit* ctx){
FrElement* circuitConstants = ctx->circuitConstants;
FrElement* signalValues = ctx->signalValues;
FrElement expaux[1];
FrElement lvar[1];
u64 mySignalStart = ctx->componentMemory[ctx_index].signalStart;
std::string myTemplateName = ctx->componentMemory[ctx_index].templateName;
std::string myComponentName = ctx->componentMemory[ctx_index].componentName;
u64 myFather = ctx->componentMemory[ctx_index].idFather;
u64 myId = ctx_index;
u32* mySubcomponents = ctx->componentMemory[ctx_index].subcomponents;
bool* mySubcomponentsParallel = ctx->componentMemory[ctx_index].subcomponentsParallel;
std::string* listOfTemplateMessages = ctx->listOfTemplateMessages;
uint sub_component_aux;
uint index_multiple_eq;
int cmp_index_ref_load = -1;
{
PFrElement aux_dest = &lvar[0];
// load src
// end load src
Fr_copy(aux_dest,&circuitConstants[0]);
}
{
std::string new_cmp_name = "hash";
Blake3Bytes_27_create(mySignalStart+64,0+ctx_index+1,ctx,new_cmp_name,myId);
mySubcomponents[0] = 0+ctx_index+1;
}
{
uint cmp_index_ref = 0;
{
PFrElement aux_dest = &ctx->signalValues[ctx->componentMemory[mySubcomponents[cmp_index_ref]].signalStart + 32];
// load src
// end load src
Fr_copyn(aux_dest,&signalValues[mySignalStart + 32],32);
}
// need to run sub component
ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter -= 32;
assert(!(ctx->componentMemory[mySubcomponents[cmp_index_ref]].inputCounter));
Blake3Bytes_27_run(mySubcomponents[cmp_index_ref],ctx);
}
{
PFrElement aux_dest = &signalValues[mySignalStart + 0];
// load src
cmp_index_ref_load = 0;
cmp_index_ref_load = 0;
// end load src
Fr_copyn(aux_dest,&ctx->signalValues[ctx->componentMemory[mySubcomponents[0]].signalStart + 0],32);
}
for (uint i = 0; i < 1; i++){
uint index_subc = ctx->componentMemory[ctx_index].subcomponents[i];
if (index_subc != 0){
assert(!(ctx->componentMemory[index_subc].inputCounter));
release_memory_component(ctx,index_subc);
}
}
}

void run(Circom_CalcWit* ctx){
Main_28_create(1,0,ctx,"main",0);
Main_28_run(0,ctx);
}


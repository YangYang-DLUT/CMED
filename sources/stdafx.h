/* Ԥ����ͷ�ļ������û������������Լӿ�����ٶȡ� */

// stdafx.h : ��׼ϵͳ�����ļ��İ����ļ���
// ���Ǿ���ʹ�õ��������ĵ�
// �ض�����Ŀ�İ����ļ�
//
#pragma once
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/core/types_c.h>

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/features2d/features2d.hpp>

#include <stdio.h>
#include <stdlib.h>
#include <algorithm>

#include <numeric>
#include <unordered_map>
#include <vector>

#include <time.h>
#include <iostream>
#include <fstream>
#include <math.h>

#include <direct.h>

#include <sys/stat.h> 

#ifdef LINUX
#include<dirent.h>
#include </usr/include/x86_64-linux-gnu/sys/io.h>
#else 
#include <io.h>
#include "dirent.h"
#endif

using namespace std;using namespace cv;